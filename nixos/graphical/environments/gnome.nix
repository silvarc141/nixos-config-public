{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.services.xserver.desktopManager.gnome.enable {
    custom.graphical.wayland.enable = true;
    services = {
      xserver = {
        enable = true;
        displayManager.gdm.enable = true;
      };
      # gnome.core-apps.enable = false;
    };
    # environment.systemPackages = with pkgs.gnomeExtensions; [
    #   tiling-assistant
    #   tiling-shell
    # ];
  };
}
