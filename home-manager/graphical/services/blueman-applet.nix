{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.services.blueman-applet.enable {
    wayland.windowManager.hyprland.settings.windowrulev2 = lib.mkIf config.wayland.windowManager.hyprland.enable [
      "tile, class:^(\.blueman-manager-wrapped)$"
    ];
  };
}
