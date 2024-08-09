{
  enable,
  pkgs,
  lib,
  ...
}: {
  config.wayland.windowManager.hyprland = lib.mkIf enable {
    enable = true;
    settings = {
      env = [
        "LIBVA_DRIVER_NAME,nvidia"
        "GBM_BACKEND,nvidia-drm"
        "GLX_VENDOR_LIBRARY_NAME,nvidia"
      ];

      exec-once = [
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        "${pkgs.waybar}/bin/waybar"
        "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"
        "${pkgs.blueman}/bin/blueman-applet"
        "${pkgs._1password-gui}/bin/1password --silent"
      ];

      monitor = "eDP-1, highres, 0x0,1";

      input = {
        kb_layout = "pl";
        kb_options = "ctrl:nocaps";
        follow_mouse = "1";
        mouse_refocus = "false";

        touchpad = {
          natural_scroll = "yes";
          disable_while_typing = "true";
        };
      };

      cursor = {
        no_hardware_cursors = "true";
        hide_on_key_press = "true";
        inactive_timeout = "2";
        persistent_warps = "true";
        warp_on_change_workspace = "true";
      };

      general = {
        gaps_in = "3";
        gaps_out = "3";
        border_size = "3";
        layout = "master";
        resize_on_border = "true";
        hover_icon_on_border = "true";
        allow_tearing = "false";
        "col.active_border" = lib.mkDefault "rgba(967bb6ff) rgba(dd85d7ff) 45deg";
        "col.inactive_border" = lib.mkDefault "rgba(595959ff)";
      };

      misc = {
        force_default_wallpaper = "0";
        disable_hyprland_logo = "yes";
        new_window_takes_over_fullscreen = "2";
        initial_workspace_tracking = "2";
      };

      decoration = {
        active_opacity = "0.9";
        inactive_opacity = "0.9";
        fullscreen_opacity = "1.0";

        rounding = "10";
        drop_shadow = "yes";
        shadow_range = "4";
        shadow_render_power = "3";
        "col.shadow" = lib.mkDefault "rgba(1a1a1aee)";
        dim_around = "0.7";

        blurls = "lockscreen";
        blur = {
          enabled = "true";
          size = "4";
          passes = "2";
          new_optimizations = "true";
          xray = "true";
          ignore_opacity = "true";
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
          "fade, 1, 8, default"
          "fadeIn, 1, 4, default"
          "fadeOut, 1, 10, default"
          "fadeSwitch, 1, 4, default"
          "workspaces, 1, 1.5, easeInOut, slidevert"
        ];
      };

      master = {
        orientation = "left";
        mfact = "0.6";
        special_scale_factor = "1";
        no_gaps_when_only = "1";
        #new_is_master = "false";
      };

      dwindle = {
        pseudotile = "true";
        default_split_ratio = "1";
        no_gaps_when_only = "1";
        force_split = "2";
        use_active_for_splits = "true";
        smart_resizing = "false";
        preserve_split = "false";
      };

      gestures.workspace_swipe = "true";
      xwayland.force_zero_scaling = "true";

      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];

      bind = [
        "SUPER, C, killactive"
        "SUPER, F, fullscreen"
        "SUPER, G, togglefloating"
        "SUPER, P, pin"
        "SUPER, return, layoutmsg, swapwithmaster"
        "SUPER, H, movefocus, l"
        "SUPER, J, movefocus, d"
        "SUPER, K, movefocus, u"
        "SUPER, L, movefocus, r"

        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"
        "SUPER, 0, workspace, 10"
        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        "SUPER SHIFT, 5, movetoworkspace, 5"
        "SUPER SHIFT, 6, movetoworkspace, 6"
        "SUPER SHIFT, 7, movetoworkspace, 7"
        "SUPER SHIFT, 8, movetoworkspace, 8"
        "SUPER SHIFT, 9, movetoworkspace, 9"
        "SUPER SHIFT, 0, movetoworkspace, 10"
        "SUPER, slash, togglespecialworkspace, scratch"
        "SUPER SHIFT, slash, movetoworkspacesilent, special:scratch"

        ", XF86AudioRaiseVolume, exec, ${pkgs.pamixer}/bin/pamixer -i 5"
        ", XF86AudioLowerVolume, exec, ${pkgs.pamixer}/bin/pamixer -d 5"
        ", XF86AudioMute, exec, ${pkgs.pamixer}/bin/pamixer -t"
        ", XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl -c backlight set +5%"
        ", XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl -c backlight set 5%-"

        "SUPER, Q, exec, ${pkgs.alacritty}/bin/alacritty"
        "SUPER, E, exec, ${pkgs.xfce.thunar}/bin/thunar"
        "SUPER, P, exec, ${pkgs.wlogout}/bin/wlogout --protocol layer-shell"
        "SUPER, B, exec, firefox" # temporary not from pkgs to launch correct wrapper binary
        "SUPER, Space, exec, pgrep \"wofi\" > /dev/null || ${pkgs.wofi}/bin/wofi --show drun --no-actions"
        "SUPER, V, exec, pgrep \"wofi\" > /dev/null || ${pkgs.cliphist}/bin/cliphist list | ${pkgs.wofi}/bin/wofi -dmenu | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy"
        "SUPER SHIFT, V, exec, ${pkgs.cliphist}/bin/cliphist wipe"
        "SUPER, S, exec, ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.swappy}/bin/swappy -f -"
      ];

      windowrule = [
        "dimaround, ^(wofi)$"
        "pin, ^(wofi)$"
        "float, ^(pavucontrol)$"
        "float, ^(nm-connection-editor)$"
        "float, ^(Bluetooth Devices)$"
      ];

      windowrulev2 = [
        "float, class:^(blueman-manager)$"
        "float, class:^(Unity)$, title:^(Unity)$"
        #"workspace special:unity silent, class:^(Unity)$, title:^(.*Unity.*)$"
      ];
    };
  };
}
