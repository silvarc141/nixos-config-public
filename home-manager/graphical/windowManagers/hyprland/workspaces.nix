{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.wayland.windowManager.hyprland.enable {
    wayland.windowManager.hyprland = {
      settings = {
        workspace = [
          # no workspace gaps when only 1 window on non-special workspaces
          "s[false] w[tv1], gapsout:0, gapsin:0"

          # master layout
          "w[tv1-999999], layoutopt:orientation:left"

          # numeric default names
          "1, defaultName:Q"
          "2, defaultName:W"
          "3, defaultName:E"
          "4, defaultName:R"
          "5, defaultName:T"
          "6, defaultName:1"
          "7, defaultName:2"
          "8, defaultName:3"
          "9, defaultName:4"
          "10, defaultName:5"
          "11, defaultName:N"
          "12, defaultName:M"
          "13, defaultName:󰸣"
          "14, defaultName:"
          "15, defaultName:"
        ];
        windowrulev2 = [
          # global
          "decorate off, class:.*"
          "norounding, floating:1"

          # no borders or rounding when only 1 window on non-special workspaces
          "noborder, floating:0, onworkspace:s[false] w[tv1]"
          "norounding, floating:0, onworkspace:s[false] w[tv1]"

          # transparent windows in special workspaces
          "opacity 0.9 override, onworkspace:s[true]"

          # pinned
          # "nofollowmouse, pinned:1"
          # "noborder, pinned:1"
          # "opacity 1 0.7, pinned:1"
        ];
      };
      mergeBind = let
        numericWorkspaces = {
          Q = "1";
          W = "2";
          E = "3";
          R = "4";
          T = "5";
          "1" = "6";
          "2" = "7";
          "3" = "8";
          "4" = "9";
          "5" = "10";
          N = "11";
          M = "12";
          comma = "13";
          period = "14";
          slash = "15";
        };
        namedWorkspaces = {};
        specialWorkspaces = {};
        mkWorkspace = shortcut: name: [
          "SUPER, ${shortcut}, workspace, ${name}"
          "SUPER SHIFT, ${shortcut}, movetoworkspacesilent, ${name}"
        ];
        mkNamedWorkspace = shortcut: name: mkWorkspace shortcut "name:${name}";
        mkSpecialWorkspace = shortcut: name: [
          "SUPER, ${shortcut}, togglespecialworkspace, ${name}"
          "SUPER SHIFT, ${shortcut}, movetoworkspacesilent, special:${name}"
        ];
      in
        [
          "SUPER, mouse_down, workspace, m-1"
          "SUPER, mouse_up, workspace, m+1"
        ]
        ++ lib.flatten (
          (lib.mapAttrsToList mkWorkspace numericWorkspaces)
          ++ (lib.mapAttrsToList mkNamedWorkspace namedWorkspaces)
          ++ (lib.mapAttrsToList mkSpecialWorkspace specialWorkspaces)
        );
    };
  };
}
