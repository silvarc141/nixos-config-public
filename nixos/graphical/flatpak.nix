{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.custom.graphical.enable {
    services.flatpak.enable = true;
    custom.ephemeral = {
      data.directories = [
        "/var/lib/flatpak/"
      ];
    };
  };
}
