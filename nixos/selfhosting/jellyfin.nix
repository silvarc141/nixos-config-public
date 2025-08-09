{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.services.jellyfin.enable {
    services.jellyfin = {
      user = config.custom.mainUser.name;
    };
    custom.ephemeral = {
      data.directories = [
        "/var/lib/jellyfin"
      ];
    };
  };
}
