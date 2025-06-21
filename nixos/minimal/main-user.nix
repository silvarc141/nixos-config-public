{
  config,
  lib,
  ...
}: let
  cfg = config.custom;
in {
  options.custom.mainUser = {
    name = lib.mkOption {
      default = "silvarc";
      type = with lib.types; uniq str;
    };
    hasSecretsAccess = lib.mkOption {
      description = "Set to true if config will have access to user secrets";
      default = false;
      type = lib.types.bool;
    };
    homeType = lib.mkOption {
      type = lib.types.enum ["minimal" "workstation" "server" "wsl"];
      default = "minimal";
    };
  };

  config = {
    users = {
      mutableUsers = false;
      users.${cfg.mainUser.name} = {
        isNormalUser = true;
        extraGroups =
          []
          ++ lib.optionals config.networking.networkmanager.enable ["networkmanager"]
          ++ lib.optionals config.custom.graphical.gaming.enable ["gamemode"]
          ++ lib.optionals config.custom.workstation.audio.enable ["audio"];
        hashedPasswordFile = config.sops.secrets.password.path;
      };
    };

    # Persist a "media" user directory for quick and direct access.
    # This is required because impermanence module for home manager uses bindfs, which can be very slow, while symlinks may be not transparent enough for some software.
    environment.persistence."${config.custom.ephemeral.settings.absoluteSystemPath}" = {
      hideMounts = true;
      users."${cfg.mainUser.name}".directories = [
        "media"
      ];
    };

    sops.secrets.password.neededForUsers = true;
  };
}
