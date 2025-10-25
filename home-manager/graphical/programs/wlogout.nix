{
  lib,
  config,
  pkgs,
  ...
}: let
  p = config.programs;
in {
  # config = lib.mkIf p.wlogout.enable {
  #   custom.graphical.desktopAgnostic.extraCommands.powerMenu = "${pkgs.wlogout}/bin/wlogout --protocol layer-shell";
  #   programs.wlogout = {
  #     enable = true;
  #     layout = [
  #       {
  #         label = "shutdown";
  #         action = "systemctl poweroff";
  #         text = "";
  #         keybind = "s";
  #       }
  #       {
  #         label = "reboot";
  #         action = "systemctl reboot";
  #         text = "";
  #         keybind = "r";
  #       }
  #       {
  #         label = "hibernate";
  #         action = "systemctl hibernate";
  #         text = "󰤄";
  #         keybind = "h";
  #       }
  #       {
  #         label = "logout";
  #         action = "loginctl kill-user $USER";
  #         text = "󰗽";
  #         keybind = "o";
  #       }
  #       {
  #         label = "lock";
  #         action = "loginctl lock-session";
  #         text = "";
  #         keybind = "l";
  #       }
  #       {
  #         label = "suspend";
  #         action = "systemctl suspend";
  #         text = "";
  #         keybind = "p";
  #       }
  #     ];
  #
  #     style =
  #       #css
  #       ''
  #         * {
  #           all: unset;
  #           background-image: none;
  #           transition: all 0.3s cubic-bezier(.55,0.0,.28,1.682);
  #           animation: gradient_f 20s ease-in infinite;
  #         }
  #
  #         window {
  #           background: transparent;
  #         }
  #
  #         button {
  #           font-size: 10rem;
  #           text-align: center;
  #           padding: 3rem;
  #         }
  #       '';
  #   };
  # };
}
