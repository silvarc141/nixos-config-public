{
  config,
  lib,
  ...
}: {
  options.programs.steam.enable = lib.mkEnableOption "enable Steam gaming platform configuration";

  config = lib.mkIf config.programs.steam.enable {
    wayland.windowManager.hyprland = lib.mkIf config.wayland.windowManager.hyprland.enable {
      settings = {
        windowrulev2 = [
          "tile, initialClass:^(steam)$"

          # dropdowns
          "float, initialClass:^(steam)$, initialTitle:^()$"
          "norounding, initialClass:^(steam)$, initialTitle:^()$"
          "noanim, initialClass:^(steam)$, initialTitle:^()$"

          "workspace 10 silent, initialClass:^(steam)$"
          "workspace special:trash silent, class:^(steam)$, title:^(.*Special Offers.*)$"
        ];
      };
    };
    custom.ephemeral = {
      data.directories = [
        ".local/share/vulkan" # precompiled shaders
        ".steam"
        # these 3 files are created in .steam
        # not sure if they can be ignored
        # ".steam/registry.vdf"
        # ".steam/steam.pid"
        # ".steam/steam.token"
      ];
      large.directories = [
        ".local/share/Steam"
      ];
    };
    # Steam setup script will fail if .local/share/Steam is a symlink pointing to a non-existing directory
    home.activation = lib.mkIf config.custom.ephemeral.enable {
      steamSetupFix = lib.hm.dag.entryAfter ["writeBoundary"] ''
        mkdir -p /persist/home/${config.home.username}/large/.local/share/Steam
      '';
    };
  };
}
