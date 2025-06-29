{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.custom.graphical.virtualization.enable {
    virtualisation.waydroid.enable = true;

    custom.ephemeral = {
      data.directories = [
        "/var/lib/waydroid"
        "/var/lib/misc"
      ];
    };
  };
}
