{
  lib,
  config,
  ...
}: let
  cmds = lib.mapAttrs (name: value: ''spawn "sh" "-c" "${value}";'') config.custom.graphical.desktopAgnostic.extraCommands;
in {
  config = lib.mkIf config.programs.niri.enable {
    programs.niri.settings = [
      # kdl
      ''
        binds {
          // launching
          Mod+Space { ${cmds.launcher} }
          Mod+T { ${cmds.terminalEmulator} }
          Mod+P { ${cmds.powerMenu} }
          Mod+B { ${cmds.browser} }
          Mod+X { ${cmds.fileManager} }
          Mod+E { ${cmds.textEditor} }
          Mod+Backslash { ${cmds.passwordManagerOpen} }

          // media
          XF86AudioRaiseVolume { ${cmds.volumeUp} }
          XF86AudioLowerVolume { ${cmds.volumeDown} }
          XF86AudioMute { ${cmds.volumeMuteToggle} }
          XF86AudioMicMute { ${cmds.micMuteToggle} }
          XF86MonBrightnessUp { ${cmds.brightnessUp} }
          XF86MonBrightnessDown { ${cmds.brightnessDown} }

          // actions
          Mod+C { close-window; }
          Mod+S { screenshot; }
          Mod+Ctrl+S { screenshot-window; }
          Mod+Shift+S { screenshot-screen; }
          // Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }
          Mod+Ctrl+Shift+Delete { quit; }

          Mod+V       { toggle-window-floating; }
          Mod+Shift+V { switch-focus-between-floating-and-tiling; }

          Mod+Shift+F { fullscreen-window; }
          Mod+F { maximize-column; }
          // Mod+C { center-column; }

          Mod+R { switch-preset-column-width; }
          Mod+Shift+R { switch-preset-window-height; }
          Mod+Ctrl+R { reset-window-height; }
          Mod+Minus { set-column-width "-10%"; }
          Mod+Equal { set-column-width "+10%"; }
          Mod+Shift+Minus { set-window-height "-10%"; }
          Mod+Shift+Equal { set-window-height "+10%"; }

          // focus
          Mod+H     { focus-column-left; }
          Mod+J     { focus-window-or-workspace-down; }
          Mod+K     { focus-window-or-workspace-up; }
          Mod+L     { focus-column-right; }

          // move
          Mod+Shift+H     { move-column-left; }
          Mod+Shift+J     { move-window-down-or-to-workspace-down; }
          Mod+Shift+K     { move-window-up-or-to-workspace-up; }
          Mod+Shift+L     { move-column-right; }

          Mod+Page_Down      { focus-workspace-down; }
          Mod+Page_Up        { focus-workspace-up; }
          Mod+U              { focus-workspace-down; }
          Mod+I              { focus-workspace-up; }
          Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
          Mod+Ctrl+Page_Up   { move-column-to-workspace-up; }
          Mod+Ctrl+U         { move-column-to-workspace-down; }
          Mod+Ctrl+I         { move-column-to-workspace-up; }

          Mod+BracketLeft  { consume-or-expel-window-left; }
          Mod+BracketRight { consume-or-expel-window-right; }

          Mod+Shift+Page_Down { move-workspace-down; }
          Mod+Shift+Page_Up   { move-workspace-up; }
          Mod+Shift+U         { move-workspace-down; }
          Mod+Shift+I         { move-workspace-up; }

          Mod+WheelScrollDown cooldown-ms=150 { focus-workspace-down; }
          Mod+WheelScrollUp cooldown-ms=150 { focus-workspace-up; }
          Mod+Shift+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
          Mod+Shift+WheelScrollUp cooldown-ms=150 { move-column-to-workspace-up; }

          Mod+WheelScrollRight { focus-column-right; }
          Mod+WheelScrollLeft { focus-column-left; }
          Mod+Shift+WheelScrollRight { move-column-right; }
          Mod+Shift+WheelScrollLeft { move-column-left; }

          Mod+1 { focus-workspace 1; }
          Mod+2 { focus-workspace 2; }
          Mod+3 { focus-workspace 3; }
          Mod+4 { focus-workspace 4; }
          Mod+5 { focus-workspace 5; }
          Mod+6 { focus-workspace 6; }
          Mod+7 { focus-workspace 7; }
          Mod+8 { focus-workspace 8; }
          Mod+9 { focus-workspace 9; }
          Mod+Shift+1 { move-column-to-workspace 1; }
          Mod+Shift+2 { move-column-to-workspace 2; }
          Mod+Shift+3 { move-column-to-workspace 3; }
          Mod+Shift+4 { move-column-to-workspace 4; }
          Mod+Shift+5 { move-column-to-workspace 5; }
          Mod+Shift+6 { move-column-to-workspace 6; }
          Mod+Shift+7 { move-column-to-workspace 7; }
          Mod+Shift+8 { move-column-to-workspace 8; }
          Mod+Shift+9 { move-column-to-workspace 9; }

          // Powers off the monitors. To turn them back on, do any input like
          // moving the mouse or pressing any other key.
          // Mod+Shift+P { power-off-monitors; }

          // Similarly, you can bind touchpad scroll "ticks".
          // Touchpad scrolling is continuous, so for these binds it is split into
          // discrete intervals.
          // These binds are also affected by touchpad's natural-scroll, so these
          // example binds are "inverted", since we have natural-scroll enabled for
          // touchpads by default.
          // Mod+TouchpadScrollDown { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.02+"; }
          // Mod+TouchpadScrollUp   { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.02-"; }


          // Mod+Home { focus-column-first; }
          // Mod+End  { focus-column-last; }
          // Mod+Ctrl+Home { move-column-to-first; }
          // Mod+Ctrl+End  { move-column-to-last; }

          // Mod+Shift+Left  { focus-monitor-left; }
          // Mod+Shift+Down  { focus-monitor-down; }
          // Mod+Shift+Up    { focus-monitor-up; }
          // Mod+Shift+Right { focus-monitor-right; }
          // Mod+Shift+H     { focus-monitor-left; }
          // Mod+Shift+J     { focus-monitor-down; }
          // Mod+Shift+K     { focus-monitor-up; }
          // Mod+Shift+L     { focus-monitor-right; }

          // Mod+Shift+Ctrl+Left  { move-column-to-monitor-left; }
          // Mod+Shift+Ctrl+Down  { move-column-to-monitor-down; }
          // Mod+Shift+Ctrl+Up    { move-column-to-monitor-up; }
          // Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
          // Mod+Shift+Ctrl+H     { move-column-to-monitor-left; }
          // Mod+Shift+Ctrl+J     { move-column-to-monitor-down; }
          // Mod+Shift+Ctrl+K     { move-column-to-monitor-up; }
          // Mod+Shift+Ctrl+L     { move-column-to-monitor-right; }

          // Alternatively, there are commands to move just a single window:
          // Mod+Shift+Ctrl+Left  { move-window-to-monitor-left; }

          // And you can also move a whole workspace to another monitor:
          // Mod+Shift+Ctrl+Left  { move-workspace-to-monitor-left; }
        }
      ''
    ];
  };
}
