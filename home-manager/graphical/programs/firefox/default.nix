{
  lib,
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.firefox-modal.homeManagerModules.default
    ./settings.nix
  ];

  config = lib.mkIf config.programs.firefox.enable {
    custom.graphical.desktopAgnostic.extraCommands.browser = "${config.programs.firefox.finalPackage}/bin/firefox";
    custom.ephemeral = {
      data.directories = [".mozilla"];

      # partial persistence only feasible if password manager has a good enough integration
      # TODO: research keepassxc-browser extension for persisting it's storage
      #
      # local = {
      #   directories = [".mozilla/firefox/Crash Reports"];
      # };
      # data = {
      #   files = [
      #     ".mozilla/firefox/${config.home.username}/places.sqlite"
      #   ];
      # };
    };
    wayland.windowManager.hyprland = lib.mkIf config.wayland.windowManager.hyprland.enable {
      settings = {
        windowrulev2 = [
          "tile, initialClass:^(firefox)$"
          "workspace 7 silent, initialClass:^(firefox)$"
        ];
      };
    };
    programs.niri.settings = lib.mkIf config.programs.niri.enable [
      ''
        window-rule {
          match app-id=r#"firefox$"# title="^Picture-in-Picture$"
          open-floating true
        }
      ''
    ];
  };
}
