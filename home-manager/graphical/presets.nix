{
  pkgs,
  config,
  lib,
  ...
}: {
  options.custom.presets.graphical = {
    basics.enable = lib.mkEnableOption "basic desktop-agnostic graphical programs";
    desktop.enable = lib.mkEnableOption "desktop-agnostic graphical programs for everyday desktop usage";
    audioProduction.enable = lib.mkEnableOption "audio production tools";
    gameDevelopment.enable = lib.mkEnableOption "game development tools";
    debug.enable = lib.mkEnableOption "general development tools";
    gaming.enable = lib.mkEnableOption "gaming";
    virtualReality.enable = lib.mkEnableOption "virtual reality tools";
  };

  config = let
    presets = {
      basics = {
        programs = {
          kitty.enable = lib.mkDefault true;
          firefox.enable = lib.mkDefault true;
          feh.enable = lib.mkDefault true;
          mpv.enable = lib.mkDefault true;
          zathura.enable = lib.mkDefault true;
          thunar.enable = lib.mkDefault true;
          waybar.enable = lib.mkDefault true;
          fuzzel.enable = lib.mkDefault true;
          wl-kbptr.enable = lib.mkDefault true;
        };
        services = {
          network-manager-applet.enable = lib.mkDefault true;
          blueman-applet.enable = lib.mkDefault true;
          udiskie.enable = lib.mkDefault true;
          wpaperd.enable = lib.mkDefault true;
          dunst.enable = lib.mkDefault true;
          pasystray.enable = lib.mkDefault true;
          swayidle.enable = lib.mkDefault true;
          cliphist.enable = lib.mkDefault true;
        };
      };
      desktop = {
        custom = {
          email.enable = lib.mkDefault true;
        };
        programs = {
          keepassxc.enable = lib.mkDefault true;
          kando.enable = lib.mkDefault true;
          vesktop.enable = lib.mkDefault true;
          obs-studio.enable = lib.mkDefault true;
          qbittorrent.enable = lib.mkDefault true;
          gimp.enable = lib.mkDefault true;
          inkscape.enable = lib.mkDefault true;
          krita.enable = lib.mkDefault true;
        };
        services = {
          activitywatch.enable = true;
        };
      };
      audioProduction = {
        programs = {
          reaper.enable = lib.mkDefault true;
          vital.enable = lib.mkDefault true;
          yabridge.enable = lib.mkDefault true;
          helvum.enable = lib.mkDefault true;
        };
        home.packages = with pkgs; [
          deepfilternet
          lilv
        ];
      };
      gameDevelopment = {
        programs = {
          unityhub.enable = lib.mkDefault true;
          rider.enable = lib.mkDefault true;
          plasticscm.enable = lib.mkDefault false;
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
          qrookie.enable = lib.mkDefault true;
          # wivrn.enable = lib.mkDefault true; # fails to build
        };
      };
      gaming = {
        programs = {
          steam.enable = true;
          lutris.enable = true;
        };
        services = {
          nix-ghkd.enable = true;
        };
      };
    };
  in
    lib.mkMerge (lib.mapAttrsToList (name: preset: lib.mkIf config.custom.presets.graphical.${name}.enable preset) presets);
}
