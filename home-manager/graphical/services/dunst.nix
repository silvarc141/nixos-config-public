{
  config,
  lib,
  ...
}: {
  services.dunst = lib.mkIf config.services.dunst.enable {
    settings = {
      global = {
        monitor = 0;
        follow = "mouse";
        width = 500;
        # height = 250;
        origin = "top-right";
        offset = "24x24";
        progress_bar = true;
        progress_bar_height = 14;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 150;
        progress_bar_max_width = 300;
        indicate_hidden = "yes";
        shrink = "no";
        transparency = 1;
        separator_height = 6;
        separator_color = "#282a36";
        padding = 16;
        horizontal_padding = 16;
        frame_width = 1;
        sort = "no";
        idle_threshold = 0;
        font = "JetBrainsMono 10";
        line_height = 0;
        markup = "full";
        format = ''<b>%a</b>\n%s'';
        alignment = ["left"];
        vertical_alignment = ["center"];
        show_age_threshold = 120;
        word_wrap = "yes";
        ellipsize = "middle";
        ignore_newline = "no";
        stack_duplicates = false;
        hide_duplicate_count = false;
        show_indicators = "no";
        icon_position = "left";
        min_icon_size = 50;
        max_icon_size = 60;
        sticky_history = "yes";
        history_length = 120;
        dmenu = config.custom.graphical.desktopAgnostic.dmenuCommand;
        browser = "${lib.getExe config.programs.firefox.finalPackage} -new-tab";
        always_run_script = false;
        title = "Dunst";
        class = "Dunst";
        corner_radius = 10;
        ignore_dbusclose = false;
        force_xinerama = false;
        mouse_left_click = "do_action, close_current";
        mouse_middle_click = "close_current";
        mouse_right_click = "context";
      };

      experimental.per_monitor_dpi = false;

      urgency_low = {
        frame_color = "#1D918B";
        highlight = "#6fa6e7";
        foreground = "#666666";
        background = "#18191E";
        timeout = 3;
      };

      urgency_normal = {
        frame_color = "#D16BB7";
        highlight = "#5ca1ff";
        foreground = "#FFFFFF";
        background = "#18191E";
        timeout = 5;
      };

      urgency_critical = {
        frame_color = "#FC2929";
        highlight = "#fe6c5a";
        foreground = "#ff4444";
        background = "#18191E";
        timeout = 20;
        icon = "battery-ac-adapter";
      };

      backlight = {
        appname = "Backlight";
        highlight = "#fc7b80";
      };

      volume = {
        summary = "Volume*";
        highlight = "#cb8cf4";
      };

      battery = {
        appname = "Power Warning";
      };

      music = {
        appname = "Music";
      };
    };
  };
}
