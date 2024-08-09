{
  pkgs,
  lib,
  config,
  ...
}: let
  cap = config.capabilities;
in
  with lib; {
    imports = [
      ./virt.nix
      ./gaming.nix
      ./hyprland.nix
    ];

    options.capabilities.graphical.enable = mkEnableOption "enable graphical configuration";

    config = mkIf cap.graphical.enable {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };

      services.greetd = {
        enable = true;
        settings.default_session.command = ''
          ${pkgs.greetd.tuigreet}/bin/tuigreet --remember --remember-session --asterisks
        '';
      };

      environment.persistence.${cap.optInPersistence.paths.system} = mkIf cap.optInPersistence.enable {
        directories = ["/var/cache/tuigreet"];
      };

      security.polkit.enable = true;

      services.flatpak.enable = true;

      programs = {
        dconf.enable = true;
        _1password-gui.enable = true;
        _1password-gui.polkitPolicyOwners = ["${cap.singleUser.name}"];
      };

      fonts.packages = with pkgs; [
        (nerdfonts.override {fonts = ["JetBrainsMono" "Iosevka"];})
      ];
    };
  }
