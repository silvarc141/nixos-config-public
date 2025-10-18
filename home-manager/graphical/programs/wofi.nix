{
  lib,
  config,
  pkgs,
  ...
}: {
  config = lib.mkIf config.programs.wofi.enable {
    custom.graphical.desktopAgnostic = let
      wofi = lib.getExe pkgs.wofi;
    in {
      dmenuCommand = "${wofi} --dmenu";
      extraCommands.launcher = "${wofi} --show drun --no-actions";
    };

    wayland.windowManager.hyprland = lib.mkIf config.wayland.windowManager.hyprland.enable {
      settings = {
        windowrule = [
          "dimaround, ^(wofi)$"
          "pin, ^(wofi)$"
        ];
      };
    };

    programs.wofi = {
      settings = {
        hide_scroll = true;
        width = "40%";
        lines = 6;
        line_wrap = "word";
        allow_markup = true;
        always_parse_args = false;
        show_all = true;
        print_command = true;
        allow_images = true;
        sort_order = "default";
        gtk_dark = true;
        prompt = "";
        image_size = 40;
        display_generic = false;
        location = "center";
        key_expand = "Tab";
        insensitive = true;
        normal_window = true;
      };
      /*
      style = ''
        * {
          font-family: Iosevka;
          color: #e5e9f0;
          background: transparent;
        }

        #window {
          background: rgba(41, 46, 66, 1.0);
          margin: auto;
          padding: 10px;
        }

        #input {
          padding: 10px;
          margin-bottom: 10px;
          border-radius: 15px;
        }

        #outer-box {
          padding: 20px;
        }

        #img {
          margin-right: 6px;
        }

        #entry {
          padding: 10px;
          border-radius: 15px;
        }

        #entry:selected {
          background-color: #2e3440;
        }

        #text {
          margin: 2px;
        }
      '';
      */
    };
  };
}
