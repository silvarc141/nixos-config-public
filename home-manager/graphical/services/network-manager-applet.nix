{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.services.network-manager-applet.enable {
    wayland.windowManager.hyprland.settings.windowrulev2 = lib.mkIf config.wayland.windowManager.hyprland.enable [
      "float, class:^(nm-connection-editor)$"
    ];
  };
}
