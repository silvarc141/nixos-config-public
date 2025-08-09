{
  lib,
  config,
  pkgs,
  ...
}: {
  config = lib.mkIf config.wayland.windowManager.hyprland.enable {
    wayland.windowManager.hyprland = let
      exec = lib.mapAttrs (name: value: "exec, ${value}") config.custom.graphical.desktopAgnostic.extraCommands;
      # hyprctl = "${pkgs.hyprland}/bin/hyprctl";
      # selectionInterfaceWrapper = pkgs.writeShellScriptBin "selection-interface-wrapper" ''
      #   ${hyprctl} dispatch submap select
      #   "$@"
      #   ${hyprctl} dispatch submap reset
      # '';
    in {
      mergeBind = [
        "SUPER, Space, ${exec.launcher}"
      ];
      # quick launch submap
      # currently submaps cannot be configured in nix syntax (https://github.com/nix-community/home-manager/issues/6062)
      extraConfig = let
        mkLaunchBind = key: command: ''
          bind = , ${key}, ${command}
          bind = , ${key}, submap, reset
          bind = SUPER, ${key}, ${command}
          bind = SUPER, ${key}, submap, reset
        '';
        launchBinds = {
          T = exec.terminalEmulator;
          B = exec.browser;
          F = exec.fileManager;
          E = exec.textEditor;
        };
        launchBindsString = lib.concatStrings (lib.mapAttrsToList (key: command: mkLaunchBind key command) launchBinds);
      in
        #hyprlang
        ''
          bind = SUPER, A, submap, Launch

          submap = Launch
          ${launchBindsString}
          bind = , escape, submap, reset
          bind = CTRL, bracketleft, submap, reset
          bind = , catchall, submap, reset
          submap = reset

          # submap = Select
          # bind = , escape, submap, reset
          # bind = , escape, submap, reset
          # bind = CTRL, bracketleft, submap, reset
          # bind = CTRL, bracketleft, submap, reset
          # bind = , catchall, submap, reset
          # bind = , catchall, submap, reset
          # submap = reset
        '';
    };
  };
}
