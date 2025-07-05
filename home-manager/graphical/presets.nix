{
  pkgs,
  config,
  lib,
  ...
}: {
  options.custom.presets.graphical = {
    basics.enable = lib.mkEnableOption "desktop-agnostic graphical programs";
    audioProduction.enable = lib.mkEnableOption "audio production tools";
    gameDevelopment.enable = lib.mkEnableOption "game development tools";
    generalDevelopment.enable = lib.mkEnableOption "general development tools";
  };

  config = let
    presets = {
      basics = {
        custom = {
          email.enable = lib.mkDefault true;
        };
        programs = {
          # alacritty.enable = lib.mkDefault true;
          kitty.enable = lib.mkDefault true;
          firefox.enable = lib.mkDefault true;
          neovide.enable = lib.mkDefault true;
          feh.enable = lib.mkDefault true;
          mpv.enable = lib.mkDefault true;
          zathura.enable = lib.mkDefault true;
          thunar.enable = lib.mkDefault true;
          keepassxc.enable = lib.mkDefault true;
          kando.enable = lib.mkDefault true;
          fuzzel.enable = lib.mkDefault true;
          waybar.enable = lib.mkDefault true;
          qbittorrent.enable = lib.mkDefault true;
          vesktop.enable = lib.mkDefault true;
          beeper.enable = lib.mkDefault true;
          obs-studio.enable = lib.mkDefault true;
          # hyprlock.enable = lib.mkDefault true;
          # wlogout.enable = lib.mkDefault true;
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
          # cbatticon.enable = lib.mkDefault true;
          # batsignal.enable = lib.mkDefault true;
        };
        home.packages = with pkgs; [
          gimp
          inkscape
        ];
      };
      audioProduction = {
        programs = {
          reaper.enable = lib.mkDefault true;
          vital.enable = lib.mkDefault true;
          yabridge.enable = lib.mkDefault true;
        };
        services = {
          # easyeffects.enable = lib.mkDefault true;
        };
        home.packages = with pkgs; [
          helvum
        ];
      };
      gameDevelopment = {
        programs = {
          unityhub.enable = lib.mkDefault true;
          rider.enable = lib.mkDefault true;
          plasticscm.enable = lib.mkDefault false;
        };
      };
      generalDevelopment = {
        home.packages = with pkgs; [
          wlrctl
          wev
          libsForQt5.qt5.qttools
          rustc
          cargo
        ];
      };
    };
  in
    lib.mkMerge (lib.mapAttrsToList (name: preset: lib.mkIf config.custom.presets.graphical.${name}.enable preset) presets);
}
