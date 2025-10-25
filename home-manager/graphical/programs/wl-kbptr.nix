{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.programs.wl-kbptr.enable {
    programs.wl-kbptr.settings = {
      general = {
        home_row_keys = "jkl;asdfghb";
        modes = "floating";
      };
      mode_floating = {
        source = "detect";
        label_color = "#9edf";
        label_select_color = "#9edf";
        unselectable_bg_color = "#2226";
        selectable_bg_color = "#334f";
        selectable_border_color = "#0000";
        label_font_family = "sans-serif";
        label_symbols = "abcdefghijklmnopqrstuvwxyz";
      };
    };
  };
}
