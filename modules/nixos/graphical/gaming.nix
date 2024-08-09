{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  options.capabilities.graphical.gaming.enable = mkEnableOption "enable gaming configuration";

  config = mkIf config.capabilities.graphical.gaming.enable {
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

    nixpkgs.config.permittedInsecurePackages = ["openssl-1.1.1w"];

    programs.gamemode.enable = true;
    programs.gamescope.enable = true;

    environment.systemPackages = with pkgs; [
      mangohud
      lutris
      protonup-ng
      protonplus
      dxvk
    ];
  };
}
