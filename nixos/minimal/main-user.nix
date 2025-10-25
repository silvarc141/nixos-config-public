{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types mkDefault optionals mkIf;
  inherit (lib.strings) hasInfix;
  cfg = config.custom;
in {
  options.custom.mainUser = {
    name = mkOption {
      default = "silvarc";
      type = with types; uniq str;
    };
    hasSecretsAccess = mkOption {
      description = "Set to true if config will have access to user secrets";
      default = false;
      type = types.bool;
    };
    homeType = mkOption {
      type = types.enum [
        "none"
        "minimal"
        "workstation"
        "workstation-travel"
        "workstation-test"
        "server"
        "wsl"
        "droid"
        "pmos"
      ];
      default = "minimal";
    };
  };

  config = {
    users = {
      mutableUsers = mkDefault false;
      users.${cfg.mainUser.name} = {
        isNormalUser = true;
        hashedPasswordFile = mkDefault config.sops.secrets.password.path;
        extraGroups = ["input"]; # needed for nix-ghkd
      };
    };

    sops.secrets.password.neededForUsers = true;

    # Persist user directories for quick and direct access.
    # This is required because impermanence module for home manager uses bindfs, which can be very slow, while symlinks may be not transparent enough for some software.
    environment.persistence."${cfg.ephemeral.settings.absoluteSystemPath}" = mkIf cfg.ephemeral.enable {
      hideMounts = true;
      users."${cfg.mainUser.name}".directories =
        [
          "unsorted"
          "archive"
        ]
        ++ optionals (cfg.workstation.configSymlink.enable) [
          "nixos"
        ]
        ++ optionals (hasInfix "workstation" cfg.mainUser.homeType) [
          "incubator"
          "projects"
          "media"
        ];
    };
  };
}
