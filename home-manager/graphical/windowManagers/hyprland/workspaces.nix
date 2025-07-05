{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.wayland.windowManager.hyprland.enable {
    wayland.windowManager.hyprland = {
      settings = {
        workspace = [
          # no workspace gaps with only 1 window on non-special workspaces
          "s[false] w[tv1], gapsout:0, gapsin:0"

          # numeric default names
          "1, defaultName:1" # 󰲠
          "2, defaultName:2" # 󰲢
          "3, defaultName:3" # 󰲤
          "4, defaultName:4" # 󰲦
          "5, defaultName:5" # 󰲨
          "6, defaultName:Q" # 󰰜
          "7, defaultName:W" # 󰰮
          "8, defaultName:E" # 󰯸
          "9, defaultName:R" # 󰰟
          "10, defaultName:T" # 󰰥
          "11, defaultName:N" # 󰰓
          "12, defaultName:M" # 󰰐
          "13, defaultName:󰸣" # 󰸥
          "14, defaultName:" # 󰻂
          "15, defaultName:" # 
        ];
        windowrulev2 = [
          # no borders or rounding with only 1 window on non-special workspaces
          "bordersize 0, floating:0, onworkspace:s[false] w[tv1]"
          "rounding 0, floating:0, onworkspace:s[false] w[tv1]"

          # transparent windows in special workspaces
          "opacity 0.9 override, onworkspace:s[true]"
        ];
      };
      mergeBind = let
        numericWorkspaces = {
          "1" = "1";
          "2" = "2";
          "3" = "3";
          "4" = "4";
          "5" = "5";
          Q = "6";
          W = "7";
          E = "8";
          R = "9";
          T = "10";
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
