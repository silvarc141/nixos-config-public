{
  config,
  lib,
  ...
}: {
  options.custom.graphical.waydroid.enable = lib.mkEnableOption "waydroid, wayland-android compatibility layer";

  config = lib.mkIf config.custom.graphical.waydroid.enable {
    virtualisation.waydroid.enable = true;
    custom.ephemeral = {
      data.directories = [
        "/var/lib/waydroid"
        "/var/lib/misc"
      ];
    };
  };
}
