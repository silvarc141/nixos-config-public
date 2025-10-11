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
  };
}
