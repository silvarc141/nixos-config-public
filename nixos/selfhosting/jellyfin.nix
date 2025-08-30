{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.services.jellyfin.enable {
    users.groups.media = {};
    users.users.jellyfin.extraGroups = [
      "media"
      "render"
      "video"
    ];
    users.users.${config.custom.mainUser.name}.extraGroups = ["media"];

    services.jellyfin = {
      openFirewall = true;
    };

    custom.ephemeral = {
      data.directories = [config.services.jellyfin.dataDir];
      cache.directories = [config.services.jellyfin.cacheDir];
    };
  };
}
