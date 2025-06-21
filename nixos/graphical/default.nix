{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.custom;
in {
  imports = lib.custom.getImportable ./.;

  options.custom.graphical = {
    enable = lib.mkEnableOption "enable graphical configuration";
    windowManager = lib.mkOption {
      type = lib.types.enum ["hyprland" "niri"];
      default = "hyprland";
    };
    sessionCommand = lib.mkOption {type = lib.types.str;};
  };

  config = lib.mkIf cfg.graphical.enable {
    programs.hyprland.enable = lib.mkIf (cfg.graphical.windowManager == "hyprland") true;
    programs.niri.enable = lib.mkIf (cfg.graphical.windowManager == "niri") true;
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
    services.greetd = {
      enable = true;
      settings = {
        initial_session = lib.mkIf cfg.boot.fullDiskEncryption.enable {
          user = cfg.mainUser.name;
          command = cfg.graphical.sessionCommand;
        };
        default_session.command = ''
          ${pkgs.greetd.tuigreet}/bin/tuigreet \
          --remember \
          --remember-session \
          --asterisks \
          --asterisks-char=# \
          --theme "border=darkgray;text=gray;prompt=gray;action=darkgray;button=gray;container=black;input=gray"
        '';
      };
    };
    programs.dconf.enable = true;
    programs.xfconf.enable = true;
    services.dbus.implementation = "broker";
    services.tumbler.enable = true;
    environment.wordlist.enable = true;
    fonts = {
      packages = with pkgs; [
        nerd-fonts.iosevka
        nerd-fonts.jetbrains-mono
      ];
    };

    # TODO: configure
    services.flatpak.enable = true;
  };
}
