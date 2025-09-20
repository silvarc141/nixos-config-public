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
          bind = SUPER, semicolon, ${exec.movePointerInActiveWindow} && ${pkgs.hyprland}/bin/hyprctl dispatch submap pointer-click
          bind = SUPER, semicolon, submap, pointer-select

          submap = pointer-select
          bind = , escape, ${exec.cancelMovePointer}
          bind = , escape, submap, reset
          bind = CTRL, bracketleft, ${exec.cancelMovePointer}
          bind = CTRL, bracketleft, submap, reset

          submap = pointer-click
          bind = , S, ${exec.simulateLeftClick}
          bind = , S, submap, reset
          bind = , D, ${exec.simulateDoubleClick}
          bind = , D, submap, reset
          bind = , M, ${exec.simulateMiddleClick}
          bind = , M, submap, reset
          bind = , R, ${exec.simulateRightClick}
          bind = , R, submap, reset
          bind = , escape, submap, reset
          bind = CTRL, bracketleft, submap, reset
          bind = , catchall, submap, reset

          submap = reset
        '';
    };
    custom = {
      graphical.desktopAgnostic.extraCommands = let
        inherit (config.programs.nushell.lib) writeNuScriptBinLib writeNuSnippet;
        wlrctl = "${pkgs.wlrctl}/bin/wlrctl";
      in {
        movePointerInActiveWindow = lib.getExe (writeNuScriptBinLib "move-pointer-in-active-window" ''
          let win = sys hypr clients | where focusHistoryID == 0 | first
          ${lib.getExe pkgs.wl-kbptr} -c ${config.xdg.configHome}/wl-kbptr/config -r $"($win.width)x($win.height)+($win.x)+($win.y)"
        '');
        cancelMovePointer = writeNuSnippet "ps | find wl-kbptr | each { kill $in.pid }";
        simulateLeftClick = writeNuSnippet "${wlrctl} pointer click left";
        simulateDoubleClick = writeNuSnippet "${wlrctl} pointer click left; ${wlrctl} pointer click left";
        simulateRightClick = writeNuSnippet "${wlrctl} pointer click right";
        simulateMiddleClick = writeNuSnippet "${wlrctl} pointer click middle";
        simulateScrollUp = writeNuSnippet "${wlrctl} pointer scroll 10 10";
        simulateScrollDown = writeNuSnippet "${wlrctl} pointer scroll -10 -10";
        movePointerRight = writeNuSnippet "${wlrctl} pointer move 10 0";
        movePointerLeft = writeNuSnippet "${wlrctl} pointer move -10 0";
        movePointerUp = writeNuSnippet "${wlrctl} pointer move 0 10";
        movePointerDown = writeNuSnippet "${wlrctl} pointer move 0 -10";
      };
    };
  };
}
