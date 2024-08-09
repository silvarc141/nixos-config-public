{
  inputs,
  config,
  lib,
  ...
}: let
  cap = config.capabilities;
in
  with lib; {
    imports = [inputs.impermanence.nixosModules.impermanence];

    options.capabilities.optInPersistence = {
      enable = mkEnableOption "enable opt-in persistence configuration";
      paths = {
        root = mkOption {
          type = types.str;
          default = "/persist";
        };
        system = mkOption {
          type = types.str;
          default = "/persist/system";
        };
        home = mkOption {
          type = types.str;
          default = "/persist/home";
        };
      };
    };

    config = mkIf cap.optInPersistence.enable {
      fileSystems.${cap.optInPersistence.paths.root}.neededForBoot = true;
      environment.persistence.${cap.optInPersistence.paths.system} = {
        hideMounts = true;
        directories = [
          "/var/log"
          "/var/lib/nixos"
          "/var/lib/systemd/coredump"
          "/etc/ssh"
          "/etc/NetworkManager/system-connections"
          {
            directory = "/var/lib/colord";
            user = "colord";
            group = "colord";
            mode = "u=rwx,g=rx,o=";
          }
          #"/root/.bash_history"
        ];
        files = [
          "/etc/machine-id"
          "/etc/nix/id_rsa"
        ];
      };

      programs.fuse.userAllowOther = true;

      # needed for home manager module
      systemd.tmpfiles.rules = mkIf cap.singleUser.enable [
        "d ${cap.optInPersistence.paths.home} 0777 root root -"
        "d ${cap.optInPersistence.paths.home}/${cap.singleUser.name} 0700 ${cap.singleUser.name} users -"
      ];
    };
  }
