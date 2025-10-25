{
  lib,
  pkgs,
  config,
  ...
}: {
  config = {
    services.hypridle = lib.mkIf config.services.hypridle.enable {
      settings = {
        general = let
          # "keepassxc --lock" pops up the window, this doesn't
          lockKeepassxcCmd = "${pkgs.libsForQt5.full}/bin/qdbus org.keepassxc.KeePassXC.MainWindow /keepassxc org.keepassxc.KeePassXC.MainWindow.lockAllDatabases";
          lockScreenCmd = "pgrep hyprlock || ${pkgs.hyprlock}/bin/hyprlock --immediate";
          fullLockCmd = "${lockKeepassxcCmd}; ${lockScreenCmd}";
        in {
          lock_cmd = fullLockCmd;
          before_sleep_cmd = lockKeepassxcCmd;
          after_sleep_cmd = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on; ${pkgs.brightnessctl}/bin/brightnessctl -r";
        };
        listener = [
          {
            timeout = 180;
            on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -s set 10%";
            on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -r";
          }
          {
            timeout = 300;
            on-timeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
            on-resume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
          }
          {
            timeout = 360;
            # add poweroff fallback
            on-timeout = ''[ ! $(lsblk -o label | grep "KEY") ] && systemctl hibernate'';
          }
        ];
      };
    };
  };
}
