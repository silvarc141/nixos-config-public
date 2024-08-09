{
  enable,
  lib,
  pkgs,
  ...
}: {
  config.services.hypridle = lib.mkIf enable {
    enable = true;
    settings = {
      lockCmd = "pgrep hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
      beforeSleepCmd = "pgrep hyprlock || ${pkgs.hyprlock}/bin/hyprlock --immediate";
      afterSleepCmd = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
      listeners = [
        {
          timeout = 120;
          onTimeout = "${pkgs.brightnessctl}/bin/brightnessctl -s set 10%";
          onResume = "${pkgs.brightnessctl}/bin/brightnessctl -r";
        }
        {
          timeout = 300;
          onTimeout = "loginctl lock-session";
        }
        {
          timeout = 360;
          onTimeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
          onResume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
        }
        {
          timeout = 600;
          onTimeout = "systemctl suspend";
        }
        {
          timeout = 1800;
          onTimeout = "systemctl hibernate";
        }
      ];
    };
  };
}
