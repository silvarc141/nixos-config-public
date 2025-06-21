{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.services.network-manager-applet.enable {
    wayland.windowManager.hyprland.settings.windowrulev2 = [
      "float, class:^(nm-connection-editor)$"
    ];
  };
}
