{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.services.pasystray.enable {
    services.pasystray = {
      extraOptions = [
        "--volume-max=${builtins.toString config.custom.audio.maxVolume}"
        "--notify=sink_default"
      ];
    };
    wayland.windowManager.hyprland = lib.mkIf config.wayland.windowManager.hyprland.enable {
      settings = {
        windowrulev2 = [
          "tile, initialClass:^(org.pulseaudio.pavucontrol)$"
        ];
      };
    };
    custom.ephemeral.data.files = [".config/pavucontrol.ini"];
  };
}
