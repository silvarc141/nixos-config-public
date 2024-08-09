{
  enable,
  pkgs,
  lib,
  ...
}: {
  config.programs.waybar = lib.mkIf enable {
    enable = true;
    systemd.enable = false;
    settings = {
      mainBar = {
        layer = "top";
        position = "bottom";
        height = 10;
        margin-bottom = 0;
        margin-top = 0;
        modules-left = ["custom/power" "custom/launcher" "custom/clipboard" "pulseaudio#output" "pulseaudio#input" "backlight" "tray"];
        modules-center = ["hyprland/workspaces"];
        modules-right = ["battery" "clock"];

        "hyprland/workspaces" = {
          sort-by-name = true;
          on-click = "activate";
        };

        "custom/power" = {
          format = "⏻";
          on-click = "${pkgs.wlogout}/bin/wlogout --protocol layer-shell";
        };

        "custom/launcher" = {
          format = "󰮫";
          on-click = "pgrep \"wofi\" > /dev/null || ${pkgs.wofi}/bin/wofi --show drun -a";
        };

        "custom/clipboard" = {
          format = "󰅍";
          on-click = "pgrep \"wofi\" > /dev/null || ${pkgs.cliphist}/bin/cliphist list | ${pkgs.wofi}/bin/wofi -dmenu | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy";
          on-click-right = "${pkgs.cliphist}/bin/cliphist wipe";
        };

        backlight = {
          format = "{icon}&#8239;{percent}";
          format-icons = ["" ""];
          scroll-step = 1;
          smooth-scrolling-threshold = 1;
          on-scroll-down = "${pkgs.brightnessctl}/bin/brightnessctl -c backlight set 1%-";
          on-scroll-up = "${pkgs.brightnessctl}/bin/brightnessctl -c backlight set +1%";
        };

        "pulseaudio#output" = {
          format = "{icon}{volume}";
          format-muted = "";
          format-bluetooth = "{icon}{volume}";
          format-bluetooth-muted = "";
          format-icons = {default = ["" "&#8239;" " "];};
          max-volume = 100;
          scroll-step = 1;
          smooth-scrolling-threshold = 1;
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
          on-click-right = "${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
        };

        "pulseaudio#input" = {
          format = "{format_source}";
          format-source = "&#8239;{volume}";
          format-source-muted = "";
          scroll-step = 1;
          smooth-scrolling-threshold = 1;
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
          on-click-right = "${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";
          on-scroll-up = "${pkgs.pulseaudio}/bin/pactl set-source-volume @DEFAULT_SOURCE@ +1%";
          on-scroll-down = "${pkgs.pulseaudio}/bin/pactl set-source-volume @DEFAULT_SOURCE@ -1%";
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon}&#8239;{capacity}%";
          format-charging = "󰂄&#8239;{capacity}%";
          format-plugged = "󰂄&#8239;{capacity}%";
          format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
        };

        clock = {
          #locale = "C";
          #format = "{ :%d.%m.%y  :%H:%M}";
        };

        tray = {
          icon-size = 16;
          spacing = 6;
        };
      };
    };
    style = ''
      *{
          font-family: Iosevka;
          font-size: 13px;
          min-height: 0;
          color: white;
      }

      window#waybar{
          background-color: rgba(0,0,0,0.5);
      }

      #workspaces{
          margin-top: 3px;
          margin-bottom: 2px;
          margin-right: 10px;
          margin-left: 25px;
      }

      #workspaces button{
          border-radius: 5px;
          margin-right: 10px;
          padding: 1px 10px;
          font-weight: bolder;
          background-color: rgba(0,0,0,0);
      }

      #workspaces button.active, #workspaces button.focused{
          background-color: rgba(1,1,1,0.3);
      }

      #custom-power,
      #custom-launcher,
      #custom-clipboard,
      #pulseaudio,
      #backlight,
      #tray,
      #battery,
      #clock {
          padding: 0 10px;
      }
    '';
  };
}
