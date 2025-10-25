{
  lib,
  config,
  ...
}: let
  inherit (lib) mkDefault mkIf mapAttrs getExe;
in {
  config = mkIf config.wayland.windowManager.hyprland.enable {
    wayland.windowManager.hyprland = {
      settings = {
        input = {
          special_fallthrough = true;
          focus_on_close = true;
          kb_layout = "pl";
          kb_options = "ctrl:nocaps";
          follow_mouse = mkDefault "1";
          follow_mouse_threshold = "100";
          mouse_refocus = mkDefault "true";
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
          no_warps = mkDefault "true";
        };
        general = {
          gaps_in = "3";
          gaps_out = "3";
          border_size = "3";
          layout = "master";
          resize_on_border = mkDefault "false";
          allow_tearing = "false";
          no_focus_fallback = "true";
          "col.active_border" = mkDefault "rgba(f5a9b8ff) rgba(5bcefaff)";
          "col.inactive_border" = mkDefault "rgba(595959ff)";
        };
        binds = {
          hide_special_on_workspace_change = true;
          focus_preferred_method = 1; # works weirdly with master/stack
        };
        misc = {
          font_family = "JetBrains Mono Nerd Font";
          force_default_wallpaper = "0";
          disable_hyprland_logo = "yes";
          new_window_takes_over_fullscreen = "2";
          focus_on_activate = "true";
          mouse_move_enables_dpms = "true";
          enable_anr_dialog = "false";
          middle_click_paste = "false";
          background_color = "0x000000";
        };
        decoration = {
          active_opacity = "1.0";
          inactive_opacity = "1.0";
          fullscreen_opacity = "1.0";
          rounding = "10";
          dim_around = "0.5";
          dim_special = "0.5";
          blur.enabled = false;
          shadow.enabled = false;
        };
        animations = {
          first_launch_animation = "false";
          bezier = [
            "overshot, 0.05, 0.9, 0.1, 1.05"
            "easeInOut, 0.75, 0, 0.25, 1"
            "revert, 1, -1, 10, 0"
          ];
          animation = [
            "windowsIn, 1, 4, overshot, gnomed"
            "windowsOut, 1, 5, overshot, gnomed"
            "windowsMove, 1, 2, overshot, slide"
            "fade, 0"
            "fadeIn, 1, 2, default"
            "fadeOut, 1, 2, default"
            "fadeLayers, 1, 2, default"
            "workspaces, 1, 0.0001, easeInOut, slidevert"
            "border, 0"
            "borderangle, 1, 50, linear, loop"
          ];
        };
        windowrulev2 = [
          # global
          "decorate off, class:.*"
          "norounding, floating:1"

          # # pinned
          # "noborder, pinned:1"
          # "nofollowmouse, pinned:1"
          # "nofocus, pinned:1"
          # "opacity 1 0.7, pinned:1"
        ];
        master = {
          mfact = "0.5";
          special_scale_factor = "0.9";
        };
        dwindle = {
          pseudotile = "true";
          force_split = "2";
          special_scale_factor = "0.95";
          split_bias = "1"; # larger current window
          preserve_split = "true";
          # default_split_ratio = "1.2"; # 0.1 - 1.9
        };
        monitor = mkDefault ", preferred, auto, 1";
        gestures.workspace_swipe = mkDefault "true";
        xwayland.force_zero_scaling = "true";
        render.direct_scanout = "true";
        group.insert_after_current = "false";
        ecosystem = {
          no_update_news = "true";
          no_donation_nag = "true";
        };
        bindm = [
          "SUPER, mouse:273, movewindow"
          "SUPER, mouse:274, resizewindow"
        ];
      };
      mergeBind = let
        inherit (config.programs.nushell.lib) writeNuScriptBinLib;
        exec = mapAttrs (name: value: "exec, ${value}") config.custom.graphical.desktopAgnostic.extraCommands;
        snippet = snippet: "exec, ${getExe (writeNuScriptBinLib "snippet" snippet)}";
      in [
        # basics
        "SUPER, C, killactive"
        "SUPER SHIFT, C, forcekillactive"
        "SUPER, F, fullscreen"
        "SUPER SHIFT, P, pseudo"

        # float
        "SUPER, Tab, ${snippet ''if (hyprctl activewindow -j | from json | get floating) { hyprctl dispatch cyclenext tiled } else { hyprctl dispatch cyclenext floating }''}"
        "SUPER SHIFT, Tab, togglefloating"

        # layout
        "SUPER, H, movefocus, l"
        "SUPER, J, movefocus, d"
        "SUPER, K, movefocus, u"
        "SUPER, L, movefocus, r"
        "SUPER SHIFT, H, swapwindow, l"
        "SUPER SHIFT, J, swapwindow, d"
        "SUPER SHIFT, K, swapwindow, u"
        "SUPER SHIFT, L, swapwindow, r"
        "SUPER SHIFT, H, moveactive, -240 0"
        "SUPER SHIFT, J, moveactive, 0 135"
        "SUPER SHIFT, K, moveactive, 0 -135"
        "SUPER SHIFT, L, moveactive, 240 0"
        "SUPER CTRL, H, resizeactive, -240 0"
        "SUPER CTRL, J, resizeactive, 0 135"
        "SUPER CTRL, K, resizeactive, 0 -135"
        "SUPER CTRL, L, resizeactive, 240 0"

        # # pin
        # "SUPER, P, ${snippet ''sys hypr clients | where pinned | get pid | each { hyprctl dispatch settiled $"pid:($in)" }''}"
        # "SUPER, P, setfloating, activewindow, tiled"
        # "SUPER, P, resizewindowpixel, exact 20% 20%, floating"
        # "SUPER, P, movewindowpixel, exact 80% 0%, floating"
        # "SUPER, P, pin"

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
