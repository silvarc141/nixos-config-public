{
  lib,
  pkgs,
  ...
}: {
  programs.hyprlock.enable = true;
  programs.waydroid.enable = true;

  # disable touchscreen to save battery
  # wayland.windowManager.hyprland.touchscreen.enable = true;

  # explicit monitor name is needed for iio-hyprland
  wayland.windowManager.hyprland.settings = {
    monitor = "eDP-1, preferred, auto, 1.333333, transform, 0";
  };

  systemd.user = {
    enable = true;
    services.iio-hyprland = {
      Service = {
        ExecStart = "${lib.getExe pkgs.iio-hyprland} --left-master";
        Restart = "on-failure";
        RestartSec = 30;
      };
      Install = {
        WantedBy = ["graphical-session.target"];
      };
    };
  };
}
