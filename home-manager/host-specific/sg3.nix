{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkForce;
in {
  wayland.windowManager.hyprland = {
    plugins = [
      "${pkgs.hyprgrass}/lib/libhyprgrass.so"
    ];
    settings = {
      monitor = mkForce ", preferred, auto, 1.333333";
      general = {
        resize_on_border = mkForce true;
      };
      gestures = {
        workspace_swipe_touch = true;
        workspace_swipe_cancel_ratio = 0.15;
      };
      plugin = {
        touch_gestures = {
          sensitivity = 4.0;
          workspace_swipe_fingers = 0;
          long_press_delay = 400;
          resize_on_border_long_press = true;
          edge_margin = 100;
          # workspace_swipe_edge = "d";

          hyprgrass-bind = [
            ", swipe:3:l, killactive"
            ", swipe:3:r, fullscreen"
            ", swipe:3:u, movetoworkspacesilent, -1"
            ", swipe:3:d, movetoworkspacesilent, +1"
            ", edge:l:r, exec, ${lib.getExe pkgs.nwg-drawer}"
            ", edge:l:u, exec, pgrep wvkbd-mobintl || ${lib.getExe pkgs.wvkbd}"
            ", edge:l:d, exec, killall wvkbd-mobintl"
          ];
        };
      };
    };
  };
}
