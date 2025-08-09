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
      type = lib.types.enum [
        "none"
        "minimal"
        "workstation"
        "workstation-travel"
        "workstation-test"
        "server"
        "wsl"
      ];
      default = "minimal";
    };
  };

  config = {
    users = {
      mutableUsers = false;
      users.${cfg.mainUser.name} = {
        isNormalUser = true;
        hashedPasswordFile = config.sops.secrets.password.path;
        extraGroups = ["input"]; # needed for nix-ghkd
      };
    };

    # Persist user directories for quick and direct access.
    # This is required because impermanence module for home manager uses bindfs, which can be very slow, while symlinks may be not transparent enough for some software.
    environment.persistence."${cfg.ephemeral.settings.absoluteSystemPath}" = lib.mkIf cfg.ephemeral.enable {
      hideMounts = true;
      users."${cfg.mainUser.name}".directories =
        [
          "nixos"
          "unsorted"
          "archive"
        ]
        ++ lib.optionals (lib.strings.hasInfix "workstation" cfg.mainUser.homeType) [
          "incubator"
          "projects"
          "media"
        ];
    };

    sops.secrets.password.neededForUsers = true;
  };
}
