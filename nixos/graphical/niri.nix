{
  lib,
  config,
  pkgs,
  ...
}: {
  config = lib.mkIf config.programs.niri.enable {
    custom.graphical = {
      wayland.enable = true;
      sessionCommand = "niri-session";
    };
    xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gnome];
  };
}
