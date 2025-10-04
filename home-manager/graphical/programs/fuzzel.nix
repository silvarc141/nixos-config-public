{
  config,
  lib,
  pkgs,
  customUtils,
  ...
}: {
  config = lib.mkIf config.programs.fuzzel.enable {
    programs.fuzzel = {
      settings = {
        main = {
          width = 60;
          tabs = 2;
          prompt = ''""'';
          dpi-aware = "no";
          font = "JetBrains Mono Nerd Font";
          layer = "top";
          terminal = ''"${config.custom.graphical.desktopAgnostic.terminalEmulatorCommand}"'';
        };
        colors = {
          background = "1e1e2eff";
          text = "cdd6f4ff";
          prompt = "bac2deff";
          placeholder = "7f849cff";
          input = "cdd6f4ff";
          match = "cba6f7ff";
          selection = "585b70ff";
          selection-text = "cdd6f4ff";
          selection-match = "cba6f7ff";
          counter = "7f849cff";
          border = "cba6f700";
        };
      };
    };
    custom.graphical.desktopAgnostic = let
      fuzzel = lib.getExe pkgs.fuzzel;
      cliphist = lib.getExe pkgs.cliphist;
      wl-copy = "${pkgs.wl-clipboard}/bin/wl-copy";
    in {
      dmenuCommand = "${fuzzel} --dmenu";
      extraCommands = let
        # uses fuzzel --index option to hide preceding line numbers that cliphist inserts
        clipboardHistorySelect =
          customUtils.writeNuScriptBin "clipboard-history-select"
          #nu
          ''
            ${cliphist} list
            | parse --regex '(\d+)\t(.*)'
            | rename id description
            | get ($in.description
              | to text
              | ${fuzzel} --dmenu --index --no-run-if-empty
              | into int)
            | format pattern "{id}\t{description}"
            | ${cliphist} decode
            | ${wl-copy}
          '';
      in {
        clipboardHistorySelect = lib.getExe clipboardHistorySelect;
        launcher = fuzzel;
      };
    };
    wayland.windowManager.hyprland = lib.mkIf config.wayland.windowManager.hyprland.enable {
      settings = {
        layerrule = [
          "dimaround, ^(launcher)$"
        ];
      };
    };
  };
}
