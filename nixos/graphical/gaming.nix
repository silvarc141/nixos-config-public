{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
in {
  options.custom.graphical.gaming.enable = mkEnableOption "gaming configuration";

  config = mkIf config.custom.graphical.gaming.enable {
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      package = pkgs.steam.override {
        extraPkgs = pkgs:
          with pkgs; [
            openssl_1_1
            freetype
            gamemode
          ];
      };
    };

    # Esync with lutris
    # https://github.com/lutris/docs/blob/master/HowToEsync.md
    # https://wiki.nixos.org/wiki/Lutris
    systemd.extraConfig = "DefaultLimitNOFILE=524288";
    security.pam.loginLimits = [
      {
        domain = config.custom.mainUser.name;
        type = "hard";
        item = "nofile";
        value = "524288";
      }
    ];

    nixpkgs.config.permittedInsecurePackages = ["openssl-1.1.1w"];

    programs.gamemode = {
      enable = true;
      settings = {
        general = {
          renice = 10;
        };
      };
    };
    users.users.${config.custom.mainUser.name}.extraGroups = ["gamemode"];
    programs.gamescope = {
      enable = true;
      # capSysNice = true; # broke something
      args = lib.mkIf config.custom.graphical.wayland.enable ["--expose-wayland"];
    };

    environment.systemPackages = with pkgs; [
      mangohud
      dxvk
      protonup-ng
    ];
  };
}
