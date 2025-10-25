{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.services.easyeffects.enable {
    custom.ephemeral.data.directories = [".config/easyeffects"];
  };
}
