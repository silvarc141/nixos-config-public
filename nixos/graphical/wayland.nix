{
  config,
  lib,
  pkgs,
  ...
}: {
  options.custom.graphical.wayland.enable = lib.mkEnableOption "enable cross-compositor Wayland configuration";

  config = lib.mkIf config.custom.graphical.wayland.enable {
    xdg.portal = {
      enable = true;
      config.common.default = "*";
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
    };
    environment.variables = {
      # hint electron apps to use wayland
      NIXOS_OZONE_WL = "1";
    };
    environment.systemPackages = [
      # required in path by waydroid for clipboard sharing
      # required in path by hyprland for image copying
      pkgs.wl-clipboard
    ];
  };
}
