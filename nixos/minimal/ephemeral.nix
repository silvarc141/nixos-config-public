{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [inputs.impermanence.nixosModules.impermanence];

  options.custom.ephemeral = let
    inherit (lib) mkEnableOption mkOption types;
    pathsSubmodule = types.submodule {
      options = {
        directories = mkOption {
          type = with types; listOf (oneOf [str attrs]);
          description = "List of directories";
          default = [];
        };
        files = mkOption {
          type = with types; listOf (oneOf [str attrs]);
          description = "List of individual files";
          default = [];
        };
      };
    };
  in {
    enable = mkEnableOption "enable opt-in persistence configuration";
    data = mkOption {
      type = pathsSubmodule;
      description = "Paths containing valuable data or imperative configuration";
      default = {};
    };
    local = mkOption {
      type = pathsSubmodule;
      description = "Paths containing non-critical files such as logs, history, swapfiles";
      default = {};
    };
    cache = mkOption {
      type = pathsSubmodule;
      description = "Paths containing temporary or intermediate files that should be wiped intermittently";
      default = {};
    };
    install = mkOption {
      type = pathsSubmodule;
      description = "Paths containing files that are generated on first system installation";
      default = {};
    };
    ignored = mkOption {
      type = pathsSubmodule;
      description = "Paths containing files that are constantly regenerated but should not be persisted";
      default = {};
    };
    settings = {
      rootPath = mkOption {
        type = types.str;
        description = "Absolute path to persistent location";
        default = "/persist";
      };
      systemPath = mkOption {
        type = types.str;
        description = "Persistent system data path relative to root path";
        default = "system";
      };
      homePath = mkOption {
        type = types.str;
        description = "Persistent home data path relative to root path";
        default = "home";
      };
      absoluteSystemPath = mkOption {
        type = types.str;
        default = let
          settings = config.custom.ephemeral.settings;
        in
          lib.concatStringsSep "/" [settings.rootPath settings.systemPath];
      };
      absoluteHomePath = mkOption {
        type = types.str;
        default = let
          settings = config.custom.ephemeral.settings;
        in
          lib.concatStringsSep "/" [settings.rootPath settings.homePath];
      };
    };
  };

  config = let
    cfg = config.custom;
    settings = cfg.ephemeral.settings;
  in
    lib.mkIf cfg.ephemeral.enable {
      fileSystems.${settings.rootPath}.neededForBoot = true;
      boot.initrd.systemd.services.root-wipe = {
        description = "wipe root filesystem";
        wantedBy = ["initrd.target"];
        before = ["sysroot.mount"];
        after = ["local-fs-pre.target"];
        serviceConfig.Type = "oneshot";
        script = ''
          mkdir /btrfs_tmp
          mount /dev/root_vg/root /btrfs_tmp

          # move existing root to old_roots
          if [[ -e /btrfs_tmp/root ]]; then
            mkdir -p /btrfs_tmp/old_roots
            timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%d_%H:%M:%S")
            mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
          fi

          # remove too old roots
          for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
            btrfs subvolume delete --recursive -- "$i"
          done

          # create a new root
          btrfs subvolume create /btrfs_tmp/root
          umount /btrfs_tmp
        '';
      };
      environment.persistence = {
        "${settings.absoluteSystemPath}/data" = {
          hideMounts = true;
          directories = cfg.ephemeral.data.directories;
          files = cfg.ephemeral.data.files;
        };
        "${settings.absoluteSystemPath}/local" = {
          hideMounts = true;
          directories = cfg.ephemeral.local.directories;
          files = cfg.ephemeral.local.files;
        };
        "${settings.absoluteSystemPath}/cache" = {
          hideMounts = true;
          directories = cfg.ephemeral.cache.directories;
          files = cfg.ephemeral.cache.files;
        };
        "${settings.absoluteSystemPath}/install" = {
          hideMounts = true;
          directories = cfg.ephemeral.install.directories;
          files = cfg.ephemeral.install.files;
        };
      };
      environment.systemPackages = let
        getPath = item:
          if builtins.isString item
          then item
          else item.directory or item.file;
        formatDir = path: path + (lib.optionalString (!lib.hasSuffix "/" path) "/") + "*";
        allSets = [
          cfg.ephemeral.data
          cfg.ephemeral.local
          cfg.ephemeral.cache
          cfg.ephemeral.install
          cfg.ephemeral.ignored
        ];
        ignoredString = lib.strings.concatStringsSep "," (
          lib.concatMap (set:
            map (lib.removePrefix "/") ((
                map formatDir (
                  map getPath set.directories
                )
              )
              ++ (map getPath set.files)))
          allSets
        );
      in [
        (pkgs.writeShellScriptBin "ephemeral-diff-system" ''
          sudo ${pkgs.fd}/bin/fd \
          --one-file-system \
          --base-directory / \
          --type f \
          --hidden \
          --exclude "{${ignoredString}}"
        '')
      ];
      custom.ephemeral = {
        data = {
          directories = [
            "/var/lib/nixos"
            {
              directory = "/var/lib/colord";
              user = "colord";
              group = "colord";
              mode = "u=rwx,g=rx,o=";
            }
          ];
          files = [
            "/etc/nix/id_rsa"
          ];
        };
        local = {
          directories = [
            "/var/log"
            "/var/lib/systemd/coredump"
          ];
          files = [
            "/var/lib/logrotate.status"
          ];
        };
        cache = {
          directories = [
            "/var/cache"
            "/tmp"
            "/root/.cache"
          ];
        };
        install = {
          files = [
            "/etc/machine-id"
          ];
        };
        ignored = {
          # directories = [
          #   "/home"
          # ];
          files = [
            "/etc/shadow"
            "/etc/passwd"
            "/etc/resolv.conf"
            "/etc/subgid"
            "/etc/subuid"
            "/etc/sudoers"
            "/etc/NIXOS"
            "/etc/group"
            "/etc/.clean"
            "/etc/.updated"
            "/var/.updated"
          ];
        };
      };

      # needed for home manager module
      systemd.tmpfiles.rules = [
        "d ${settings.absoluteHomePath} 0777 root root -"
        "d ${settings.absoluteHomePath}/${cfg.mainUser.name} 0700 ${cfg.mainUser.name} users -"
      ];
      programs.fuse.userAllowOther = true;
    };
}
