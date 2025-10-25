{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) getExe mkIf mkEnableOption;
  extraCommands = config.custom.graphical.desktopAgnostic.extraCommands;
  toggleWvkbd = pkgs.writeShellScriptBin "toggle-wvkbd" ''
    if pgrep -x "wvkbd-mobintl" > /dev/null
    then
      pkill -SIGRTMIN wvkbd-mobintl
    else
      ${getExe pkgs.wvkbd} \
      -L 500 \
      -H 500 \
      -R 15 \
      -fn "Iosevka Term SS14 30" \
      -l "simple,special" \
      &
    fi
  '';
in {
  options.wayland.windowManager.hyprland.touchscreen.enable = mkEnableOption "touchscreen support on hyprland";

  config.wayland.windowManager.hyprland = mkIf (config.wayland.windowManager.hyprland.enable && config.wayland.windowManager.hyprland.touchscreen.enable) {
    plugins = [pkgs.hyprlandPlugins.hyprgrass];
    settings = {
      ecosystem.enforce_permissions = false;
      layerrule = [
        # rules for wvkbd, change from "wlroots" to "wvkbd" when it is updated in nixpkgs
        "abovelock true, ^(wlroots)$"
        "animation slide left, ^(wl-roots)$"
      ];
      input = {
        follow_mouse = "0";
        mouse_refocus = "false";
      };
      gestures = {
        workspace_swipe = false;
        workspace_swipe_touch = false;
        workspace_swipe_cancel_ratio = 0.25;
      };
      plugin = {
        touch_gestures = {
          sensitivity = 8.0;
          workspace_swipe_fingers = 50;
          workspace_swipe_edge = false;
          long_press_delay = 400;
          resize_on_border_long_press = true;
          edge_margin = 100;

          hyprgrass-bind = [
            ", edge:u:d, workspace, m-1"
            ", edge:u:rd, workspace, m-1"
            ", edge:u:ld, workspace, m-1"
            # ", edge:u:l, workspace, m-1"
            # ", edge:u:r, workspace, m-1"

            ", edge:d:u, workspace, m+1"
            ", edge:d:ru, workspace, m+1"
            ", edge:d:lu, workspace, m+1"
            # ", edge:d:l, workspace, m+1"
            # ", edge:d:r, workspace, m+1"

            ", edge:r:l, global, kando:main"
            ", edge:r:ld, global, kando:main"
            ", edge:r:lu, global, kando:main"
            # ", edge:r:u, global, kando:main"
            # ", edge:r:d, global, kando:main"

            ", edge:l:r, exec, ${getExe toggleWvkbd}"
            ", edge:l:rd, exec, ${getExe toggleWvkbd}"
            ", edge:l:ru, exec, ${getExe toggleWvkbd}"
            # ", edge:l:u, exec, ${getExe toggleWvkbd}"
            # ", edge:l:d, exec, ${getExe toggleWvkbd}"

            ", swipe:3:l, killactive"
            ", swipe:3:r, fullscreen"
            ", swipe:3:u, movetoworkspace, -1"
            ", swipe:3:d, movetoworkspace, +1"

            ", swipe:4:l, forcekillactive"
            ", swipe:4:r, togglefloating"
            ", swipe:4:u, movetoworkspacesilent, -1"
            ", swipe:4:d, movetoworkspacesilent, +1"

            ", tap:6, exec, ${extraCommands.terminalEmulator}"
          ];
          hyprgrass-bindl = [
            ", tap:5, exec, ${getExe toggleWvkbd}"
          ];
          hyprgrass-bindm = [
            ", longpress:3, movewindow"
            ", longpress:4, resizewindow"
          ];
        };
      };
    };
  };
}
