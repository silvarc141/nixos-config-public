{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) getExe mkIf mkEnableOption;
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
      general = {
        resize_on_border = true;
      };
      input = {
        follow_mouse = "0";
        mouse_refocus = "false";
      };
      gestures = {
        workspace_swipe_touch = true;
        workspace_swipe_cancel_ratio = 0.15;
      };
      plugin = {
        touch_gestures = {
          sensitivity = 8.0;
          workspace_swipe_fingers = 0;
          long_press_delay = 400;
          resize_on_border_long_press = true;
          edge_margin = 200;

          hyprgrass-bind = [
            ", swipe:3:l, killactive"
            ", swipe:3:r, fullscreen"
            ", swipe:3:u, movetoworkspace, -1"
            ", swipe:3:d, movetoworkspace, +1"
            ", edge:r:l, global, kando:main"
            ", edge:l:r, exec, ${getExe toggleWvkbd}"
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
