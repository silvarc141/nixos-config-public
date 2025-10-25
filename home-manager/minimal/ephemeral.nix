{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.custom;
  # should be connected with homePath from nixos config, only when used as a nixos module
  basePath = "/persist/home/${config.home.username}";
  dataPath = basePath + "/data";
  localPath = basePath + "/local";
  cachePath = basePath + "/cache";
  largePath = basePath + "/large";
in {
  imports = [inputs.impermanence.nixosModules.home-manager.impermanence];

  options.custom.ephemeral = let
    inherit (lib) types mkOption mkEnableOption;
    pathsSubmodule = types.submodule {
      options = {
        directories = mkOption {
          type = types.listOf types.str;
          description = "List of directories";
          default = [];
        };
        files = mkOption {
          type = types.listOf types.str;
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
    large = mkOption {
      type = pathsSubmodule;
      description = "Paths containing non-critical but huge files that can be behind a symlink";
      default = {};
    };
    ignored = mkOption {
      type = pathsSubmodule;
      description = "Paths containing files that are constantly regenerated but should not be persisted";
      default = {};
    };
  };

  config = lib.mkIf cfg.ephemeral.enable {
    home.persistence = {
      "${dataPath}" = {
        allowOther = true;
        directories = cfg.ephemeral.data.directories;
        files = cfg.ephemeral.data.files;
      };
      "${localPath}" = {
        allowOther = true;
        directories = cfg.ephemeral.local.directories;
        files = cfg.ephemeral.local.files;
      };
      "${largePath}" = {
        allowOther = true;
        directories =
          map (path: {
            directory = path;
            method = "symlink";
          })
          cfg.ephemeral.large.directories;
        files =
          map (path: {
            directory = path;
            method = "symlink";
          })
          cfg.ephemeral.large.files;
      };
      "${cachePath}" = {
        allowOther = true;
        directories = cfg.ephemeral.cache.directories;
        files = cfg.ephemeral.cache.files;
      };
    };

    home.packages = let
      ignoredString = lib.strings.concatStringsSep "," (cfg.ephemeral.ignored.directories ++ cfg.ephemeral.ignored.files);
    in
      with pkgs; [
        (writeShellScriptBin "ephemeral-diff-home" ''
          ${fd}/bin/fd \
          --one-file-system \
          --base-directory ${config.home.homeDirectory} \
          --type f \
          --hidden \
          --exclude "{${ignoredString}}"
        '')
      ];

    custom.ephemeral = {
      local = {
        directories = [
          ".local/share/systemd/timers"
        ];
      };
      cache = {
        directories = [
          ".cache"
        ];
      };
    };
  };
}
