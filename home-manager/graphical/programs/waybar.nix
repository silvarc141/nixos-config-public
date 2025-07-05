{
  lib,
  config,
  pkgs,
  ...
}: {
  config = {
    programs.waybar = lib.mkIf config.programs.waybar.enable {
      systemd.enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "bottom";
          modules-left = ["custom/launcher"];
          modules-center = ["hyprland/workspaces"];
          modules-right = ["hyprland/submap" "tray" "battery" "clock"];
          "hyprland/workspaces" = {
            sort-by-name = true;
            on-click = "activate";
          };
          clock = {
            locale = "C";
            format = "{:%d.%m | %H:%M}";
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
          "custom/scratch" = {
            format = "";
            on-click = pkgs.writeShellScript "toggle-terminal" "hyprctl dispatch togglespecialworkspace scratch";
          };
          "custom/launcher" = {
            format = "&#8239;";
            on-click = config.custom.graphical.desktopAgnostic.extraCommands.launcher;
          };
        };
      };
      style =
        #css
        ''
          * {
            font-family: Iosevka;
            font-size: 15px;
          }
          #waybar {
            background: @base;
            color: @lavender;
          }
          button {
            color: @lavender;
            border-radius: 15px;
          }
          button:hover {
            background-color: @sky;
          }
          button.active {
            background-color: @surface1;
            color: @sky;
          }
          #tray,
          #clock,
          #battery,
          #workspaces,
          #custom-launcher,
          #custom-scratch {
            background-color: @surface0;
            border-radius: 15px;
            margin-left: 3px;
            margin-right: 3px;
            padding-left: 12px;
            padding-right: 12px;
          }
          #workspaces {
            margin-left: 10px;
            margin-right: 10px;
            padding-left: 0px;
            padding-right: 0px;
          }
          #clock {
            color: @blue;
          }
          #battery {
            color: @green;
          }
          #battery.charging {
            color: @yellow;
          }
          #battery.warning:not(.charging) {
            color: @peach;
          }
          #battery.critical:not(.charging) {
            color: @red;
          }
          #backlight {
            color: @yellow;
          }
        '';
    };
  };
}
