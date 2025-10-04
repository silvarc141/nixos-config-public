{
  lib,
  config,
  pkgs,
  ...
}: {
  config = lib.mkIf config.programs.hyprland.enable {
    custom.graphical = {
      wayland.enable = true;
      sessionCommand = "Hyprland";
    };
    services.greetd.enable = true;
    programs.hyprland = {
      withUWSM = true;
    };
    xdg.portal = {
      configPackages = [pkgs.xdg-desktop-portal-hyprland];
      extraPortals = [pkgs.xdg-desktop-portal-hyprland];
    };
    nix = {
      settings = {
        substituters = ["https://hyprland.cachix.org"];
        trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
      };
    };
  };
}
