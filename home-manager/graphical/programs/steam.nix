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

          # games
          "workspace 9 silent, initialClass:^(steam_app_.*)$"
        ];
      };
    };
    custom.ephemeral = {
      data.directories = [
        ".local/share/vulkan" # precompiled shaders
      ];
      large.directories = [
        ".local/share/Steam"
      ];
      ignored.files = [
        # TODO: make sure wivrn works correctly, ignored for now
        ".config/openvr/openvrpaths.vrpath"

        # these 3 files are created in .steam
        # not sure if they can be ignored
        # .steam cannot be persisted, and steam seems to break when these files are persisted as files
        ".steam/registry.vdf"
        ".steam/steam.pid"
        ".steam/steam.token"
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
