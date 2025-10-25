{
  pkgs,
  lib,
  config,
  customUtils,
  ...
}: let
  cfg = config.custom;
in {
  imports = customUtils.getImportable ./.;

  options.custom.graphical = {
    enable = lib.mkEnableOption "enable graphical configuration";
    windowManager = lib.mkOption {
      type = lib.types.enum ["hyprland" "niri" "gnome"];
      default = "hyprland";
    };
    sessionCommand = lib.mkOption {type = lib.types.str;};
  };

  config = lib.mkIf cfg.graphical.enable {
    programs.hyprland.enable = lib.mkIf (cfg.graphical.windowManager == "hyprland") true;
    programs.niri.enable = lib.mkIf (cfg.graphical.windowManager == "niri") true;
    services.xserver.desktopManager.gnome.enable = lib.mkIf (cfg.graphical.windowManager == "gnome") true;

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
    programs.dconf.enable = true;
    programs.xfconf.enable = true;
    services.dbus.implementation = "broker";
    fonts = {
      packages = with pkgs; [
        (iosevka-bin.override {variant = "SGr-IosevkaTermSS14";})
        nerd-fonts.symbols-only
        nerd-fonts.jetbrains-mono
      ];
    };

    # move somewhere fitting
    environment.wordlist.enable = true;
    services.tumbler.enable = true;
  };
}
