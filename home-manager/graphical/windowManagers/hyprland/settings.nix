{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.wayland.windowManager.hyprland.enable {
    wayland.windowManager.hyprland = {
      settings = {
        input = {
          special_fallthrough = true;
          focus_on_close = true;
          kb_layout = "pl";
          kb_options = "ctrl:nocaps";
          follow_mouse = "1";
          follow_mouse_threshold = "100";
          mouse_refocus = "false";
          touchpad = {
            natural_scroll = "yes";
            disable_while_typing = "true";
            scroll_factor = "0.5";
          };
        };
        cursor = {
          enable_hyprcursor = "false";
          no_hardware_cursors = "1";
          inactive_timeout = "2";
          no_warps = "true";
        };
        general = {
          gaps_in = "3";
          gaps_out = "3";
          border_size = "3";
          layout = "dwindle";
          resize_on_border = "true";
          hover_icon_on_border = "true";
          allow_tearing = "false";
          no_focus_fallback = "true";
          "col.active_border" = lib.mkDefault "rgba(f5a9b8ff) rgba(5bcefaff)";
          "col.inactive_border" = lib.mkDefault "rgba(595959ff)";
        };
        misc = {
          font_family = "JetBrains Mono Nerd Font";
          force_default_wallpaper = "0";
          disable_hyprland_logo = "yes";
          new_window_takes_over_fullscreen = "2";
          focus_on_activate = "true";
          mouse_move_enables_dpms = "true";
          enable_anr_dialog = "false";
        };
        decoration = {
          active_opacity = "1.0";
          inactive_opacity = "1.0";
          fullscreen_opacity = "1.0";
          rounding = "10";
          dim_around = "0.5";
          dim_special = "0.5";
          blur = {
            enabled = true;
            xray = false;
            size = "4";
            passes = "2";
            new_optimizations = "true";
            ignore_opacity = "true";
          };
          shadow = {
            enabled = false;
          };
        };
        animations = {
          enabled = "yes";
          first_launch_animation = "false";
          bezier = [
            "overshot, 0.05, 0.9, 0.1, 1.05"
            "easeInOut, 0.75, 0, 0.25, 1"
            "revert, 1, -1, 10, 0"
          ];
          animation = [
            "windowsIn, 1, 3, overshot"
            "windowsOut, 1, 10, revert"
            "windowsMove, 1, 2, overshot"
            "border, 1, 1.5, easeInOut"
            "borderangle, 1, 8, default"
            "fade, 1, 4, default"
            "fadeOut, 1, 10, default"
            "fadeLayers, 1, 2, default"
            "fadeDim, 1, 8, default"
            "workspaces, 1, 1.5, easeInOut, slidevert"
            "border, 1, 0.2, default"
            "borderangle, 1, 50, linear, loop"
          ];
        };
        master = {
          orientation = "left";
          mfact = "0.6";
          special_scale_factor = "0.9";
        };
        dwindle = {
          pseudotile = "true";
          preserve_split = "true";
          force_split = "2";
          special_scale_factor = "0.95";
          default_split_ratio = "1.2"; # 0.1 - 1.9
          split_bias = "1"; # larger current window
        };
        monitor = ", preferred, auto, 1";
        gestures.workspace_swipe = "true";
        xwayland.force_zero_scaling = "true";
        ecosystem.no_update_news = "true";
        render.direct_scanout = "true";
        group.insert_after_current = "false";
        bindm = [
          "SUPER, mouse:273, movewindow"
          "SUPER, mouse:274, resizewindow"
        ];
      };
      mergeBind = let
        exec = lib.mapAttrs (name: value: "exec, ${value}") config.custom.graphical.desktopAgnostic.extraCommands;
      in [
        # basics
        "SUPER, C, killactive"
        "SUPER SHIFT, C, forcekillactive"
        "SUPER, F, fullscreen"
        "SUPER SHIFT, F, togglefloating"
        "SUPER, P, pseudo"
        "SUPER SHIFT, P, pin"

        # dwindle layout
        "SUPER, H, movefocus, l"
        "SUPER, J, movefocus, d"
        "SUPER, K, movefocus, u"
        "SUPER, L, movefocus, r"
        "SUPER SHIFT, H, swapwindow, l"
        "SUPER SHIFT, J, swapwindow, d"
        "SUPER SHIFT, K, swapwindow, u"
        "SUPER SHIFT, L, swapwindow, r"
        "SUPER SHIFT, H, moveactive, -192 0"
        "SUPER SHIFT, J, moveactive, 0 108"
        "SUPER SHIFT, K, moveactive, 0 -108"
        "SUPER SHIFT, L, moveactive, 192 0"
        "SUPER CTRL, H, resizeactive, -192 0"
        "SUPER CTRL, J, resizeactive, 0 108"
        "SUPER CTRL, K, resizeactive, 0 -108"
        "SUPER CTRL, L, resizeactive, 192 0"

        # password manager
        "SUPER, backslash, ${exec.passwordManagerOpen}"
        "SUPER CONTROL, backslash, ${exec.passwordManagerSelect}"
        "SUPER SHIFT, backslash, ${exec.passwordManagerSelectTOTP}"

        # media control
        ", XF86AudioRaiseVolume, ${exec.volumeUp}"
        ", XF86AudioLowerVolume, ${exec.volumeDown}"
        ", XF86AudioMute, ${exec.volumeMuteToggle}"
        ", XF86AudioMicMute, ${exec.micMuteToggle}"
        ", XF86MonBrightnessUp, ${exec.brightnessUp}"
        ", XF86MonBrightnessDown, ${exec.brightnessDown}"
      ];
    };
  };
}
