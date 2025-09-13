{
  lib,
  config,
  ...
}: let
  cfg = config.custom;
in {
  config = lib.mkIf config.programs.obs-studio.enable {
    custom.ephemeral.data = {
      directories = [
        ".config/obs-studio"
      ];
    };
  };
}
