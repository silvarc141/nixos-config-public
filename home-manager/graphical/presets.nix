{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkDefault mkEnableOption mkIf mkMerge mapAttrsToList;
in {
  options.custom.presets.graphical = {
    basics.enable = mkEnableOption "basic desktop-agnostic graphical programs";
    desktop.enable = mkEnableOption "desktop-agnostic graphical programs for everyday desktop usage";
    audioProduction.enable = mkEnableOption "audio production tools";
    unityDevelopment.enable = mkEnableOption "Unity engine game development tools";
    debug.enable = mkEnableOption "general development tools";
    gaming.enable = mkEnableOption "gaming";
    virtualReality.enable = mkEnableOption "virtual reality tools";
  };

  config = let
    presets = {
      basics = {
        programs = {
          kando.enable = mkDefault true;
          waybar.enable = mkDefault true;
          fuzzel.enable = mkDefault true;
          wl-kbptr.enable = mkDefault true;

          kitty.enable = mkDefault true;
          firefox.enable = mkDefault true;
          thunar.enable = mkDefault true;

          xarchiver.enable = mkDefault true;
          feh.enable = mkDefault true;
          mpv.enable = mkDefault true;
          zathura.enable = mkDefault true;

          keepassxc.enable = mkDefault true;
        };
        services = {
          network-manager-applet.enable = mkDefault true;
          blueman-applet.enable = mkDefault true;
          udiskie.enable = mkDefault true;
          wpaperd.enable = mkDefault true;
          dunst.enable = mkDefault true;
          pasystray.enable = mkDefault true;
          swayidle.enable = mkDefault true;
          cliphist.enable = mkDefault true;
          flatpak.enable = mkDefault true;
        };
      };
      desktop = {
        programs = {
          vesktop.enable = mkDefault true;
          obs-studio.enable = mkDefault true;
          qbittorrent.enable = mkDefault true;
          gimp.enable = mkDefault true;
          inkscape.enable = mkDefault true;
          krita.enable = mkDefault true;
          mission-center.enable = mkDefault true;
          beeper.enable = mkDefault true;
          slack.enable = mkDefault true;
          thunderbird.enable = mkDefault true;
          # zed-editor.enable = mkDefault true;
        };
        # services = {
        #   activitywatch.enable = mkDefault true;
        # };
        # custom = {
        #   email.enable = mkDefault true;
        # };
      };
      audioProduction = {
        programs = {
          reaper.enable = mkDefault true;
          vital.enable = mkDefault true;
          yabridge.enable = mkDefault true;
          helvum.enable = mkDefault true;
        };
        home.packages = with pkgs; [
          deepfilternet
          lilv
        ];
      };
      unityDevelopment = {
        programs = {
          unityhub.enable = mkDefault true;
          rider.enable = mkDefault true;
          # plasticscm.enable = mkDefault true;
        };
      };
      debug = {
        home.packages = with pkgs; [
          wev
          libsForQt5.qt5.qttools
          wlrctl
        ];
      };
      virtualReality = {
        programs = {
          qrookie.enable = mkDefault true;
        };
        services = {
          wivrn.enable = mkDefault true;
        };
      };
      gaming = {
        programs = {
          steam.enable = true;
          lutris.enable = true;
        };
        # TODO: fix "failing by design" to enable
        # services = {
        #   nix-ghkd.enable = true;
        # };
      };
    };
  in
    mkMerge (mapAttrsToList (name: preset: mkIf config.custom.presets.graphical.${name}.enable preset) presets);
}
