{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.wayland.windowManager.hyprland.enable {
    wayland.windowManager.hyprland.mergeBind = let
      exec = lib.mapAttrs (name: value: "exec, ${value}") config.custom.graphical.desktopAgnostic.extraCommands;
    in [
      "SUPER, S, ${exec.screenshotActiveWindowToClipboard}"
      "SUPER, D, ${exec.saveClipboardAsPNG}" # mnemonic: disk
      "SUPER, V, ${exec.clipboardHistorySelect}"
      "SUPER SHIFT, V, ${exec.clipboardHistoryWipe}"

      # mouse required
      "SUPER, F1, ${exec.screenshotRegionToClipboard}"
      "SUPER, F2, ${exec.annotateImageFromClipboard}"
    ];
    custom = {
      graphical.desktopAgnostic.extraCommands = let
        inherit (config.programs.nushell.lib) writeNuScriptBinLib;
      in {
        screenshotActiveWindowToClipboard = lib.getExe (writeNuScriptBinLib "screenshot-active-window-to-clipboard" ''
          let win = sys hypr clients | where focusHistoryID == 0
          let x = $win.x | to text -n
          let y = $win.y | to text -n
          let width = $win.width | to text -n
          let height = $win.height | to text -n
          ${lib.getExe pkgs.grim} -g $"($x),($y) ($width)x($height)" - | wl-copy
        '');
      };
    };
    home.packages = with pkgs; [
      wl-clipboard # required in path to properly copy images
    ];
  };
}
