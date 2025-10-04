{
  lib,
  config,
  ...
}: {
  config = {
    programs.waybar = lib.mkIf config.programs.waybar.enable {
      systemd.enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "right";
          modules-left = ["hyprland/workspaces"];
          modules-center = [];
          modules-right = ["tray" "battery" "clock#date" "clock"];
          "hyprland/workspaces" = {
            sort-by-name = true;
            on-click = "activate";
            on-scroll-up = "hyprctl dispatch workspace m-1";
            on-scroll-down = "hyprctl dispatch workspace m+1";
          };
          tray = {
            spacing = 4;
            reverse-direction = true;
          };
          clock = {
            justify = "center";
            locale = "C";
            format = "\n{:%H\n%M}";
          };
          "clock#date" = {
            justify = "center";
            locale = "C";
            format = "\n{:%d\n%m}";
          };
          battery = {
            justify = "center";
            hide-empty-text = true;
            states = {
              full = 100;
              normal = 99;
              warning = 30;
              critical = 15;
            };
            format-full = "";
            format-normal = "󱐋\n{capacity}";
            format-warning = "󱐋\n{capacity}";
            format-critical = "󱐋\n{capacity}";
          };
        };
      };
      style =
        #css
        ''
          * {
            font-family: Iosevka Term SS14, Symbols Nerd Font Mono, sans-serif;
            font-size: 15px;
            margin-left: 0px;
            margin-right: 0px;
            margin-top: 0px;
            margin-bottom: 0px;
            padding-left: 0px;
            padding-right: 0px;
            padding-top: 0px;
            padding-bottom: 0px;
          }
          #waybar {
            background: @base;
            color: @lavender;
          }
          button {
            color: @lavender;
          }
          button:hover {
            background-color: @surface2;
          }
          button.active {
            background-color: @surface1;
          }
          button.active:hover {
            background-color: @surface1;
          }
          #tray,
          #clock,
          #battery {
            margin-top: 10px;
          }
          #tray {
            margin-bottom: 3px;
          }
          #clock.date {
            color: @pink;
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
        '';
    };
  };
}
