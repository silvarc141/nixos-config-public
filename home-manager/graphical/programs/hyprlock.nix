{
  lib,
  config,
  pkgs,
  ...
}: {
  config = lib.mkIf config.programs.hyprlock.enable {
    custom.graphical.desktopAgnostic.extraCommands.screenLock = lib.getExe pkgs.hyprlock;
    programs.hyprlock = {
      settings = {
        general = {
          hide_cursor = true;
        };
        background = [
          {
            path = "screenshot";
            blur_passes = 2;
          }
        ];
        input-field = [
          {
            position = "0, -20";
            halign = "center";
            valign = "center";
            size = "1200, 200";
            outline_thickness = 0;
            dots_size = 0.33; # Scale of input-field height, 0.2 - 0.8
            dots_spacing = 0.15; # Scale of dots' absolute size, 0.0 - 1.0
            dots_center = false;
            dots_rounding = -2; # -1 default circle, -2 follow input-field rounding
            outer_color = "rgb(151515)";
            inner_color = "rgb(200, 200, 200)";
            font_color = "rgb(10, 10, 10)";
            fade_on_empty = true;
            fade_timeout = 250; # Milliseconds before fade_on_empty is triggered.
            placeholder_text = ""; # Text rendered in the input box when it's empty.
            hide_input = false;
            rounding = 15; # -1 means complete rounding (circle/oval)

            check_color = "rgb(204, 136, 34)";

            fail_color = "rgb(204, 34, 34)"; # if authentication failed, changes outer_color and fail message color
            fail_text = ""; # can be set to empty
            fail_timeout = 2000; # milliseconds before fail_text and fail_color disappears
            fail_transition = 300; # transition time in ms between normal outer_color and fail_color

            capslock_color = -1;
            numlock_color = -1;
            bothlock_color = -1; # when both locks are active. -1 means don't change outer color (same for above)
            invert_numlock = false; # change color if numlock is off
            swap_font_color = false; # see below
          }
        ];
      };
    };
  };
}
