{
  lib,
  pkgs,
  ...
}: {
  programs.hyprlock.enable = true;
  wayland.windowManager.hyprland.touchscreen.enable = true;
  custom.presets.graphical.gaming.enable = true;

  # explicit monitor name is needed for iio-hyprland
  wayland.windowManager.hyprland.settings = {
    monitor = "eDP-1, preferred, auto, 1.333333, transform, 0";
    cursor = {
      # - hyprgrass breaks some functionality: https://github.com/horriblename/hyprgrass/issues/146
      no_warps = "false";
    };
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
