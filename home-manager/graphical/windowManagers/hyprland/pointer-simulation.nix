{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.wayland.windowManager.hyprland.enable {
    wayland.windowManager.hyprland = let
      exec = lib.mapAttrs (name: value: "exec, ${value}") config.custom.graphical.desktopAgnostic.extraCommands;
    in {
      # keyboard-based pointer navigation submap
      # currently submaps cannot be configured in nix syntax (https://github.com/nix-community/home-manager/issues/6062)
      extraConfig =
        #hyprlang
        ''
          bind = SUPER, semicolon, ${exec.movePointerInActiveWindow} && ${pkgs.hyprland}/bin/hyprctl dispatch submap Pointer

          submap = Pointer

          bind = , S, ${exec.simulateLeftClick}
          bind = , D, ${exec.simulateMiddleClick}
          bind = , F, ${exec.simulateRightClick}

          bind = , S, submap, reset
          bind = , D, submap, reset
          bind = , F, submap, reset
          bind = , escape, submap, reset
          bind = CTRL, bracketleft, submap, reset
          bind = , catchall, submap, reset

          submap = reset
        '';
    };
    custom = {
      graphical.desktopAgnostic.extraCommands = let
        inherit (lib.custom) mkNuScriptlet;
        wlrctl = "${pkgs.wlrctl}/bin/wlrctl";
      in {
        movePointerInActiveWindow = mkNuScriptlet ''
          let win = sys clients | where focusHistoryID == 0 | first
          wl-kbptr -c ${config.xdg.configHome}/wl-kbptr/config -r $"($win.width)x($win.height)+($win.x)+($win.y)" --output eDP-1
        '';
        simulateLeftClick = mkNuScriptlet "${wlrctl} pointer click left";
        simulateRightClick = mkNuScriptlet "${wlrctl} pointer click right";
        simulateMiddleClick = mkNuScriptlet "${wlrctl} pointer click middle";
        simulateScrollUp = mkNuScriptlet "${wlrctl} pointer scroll 10 10";
        simulateScrollDown = mkNuScriptlet "${wlrctl} pointer scroll -10 -10";
        movePointerRight = mkNuScriptlet "${wlrctl} pointer move 10 0";
        movePointerLeft = mkNuScriptlet "${wlrctl} pointer move -10 0";
        movePointerUp = mkNuScriptlet "${wlrctl} pointer move 0 10";
        movePointerDown = mkNuScriptlet "${wlrctl} pointer move 0 -10";
      };
    };
  };
}
