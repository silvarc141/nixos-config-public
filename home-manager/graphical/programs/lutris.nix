{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.programs.lutris.enable {
    custom.ephemeral.data = {
      directories = [
        ".local/share/lutris"
        ".local/share/umu"
      ];
    };
    wayland.windowManager.hyprland = lib.mkIf config.wayland.windowManager.hyprland.enable {
      settings = {
        windowrulev2 = [
          "tile, initialClass:^(net\.lutris\.Lutris)$"
          "workspace 10 silent, initialClass:^(net\.lutris\.Lutris)$"
          "workspace special:trash silent, title:^(Wine System Tray)$"
        ];
      };
    };
  };
}
