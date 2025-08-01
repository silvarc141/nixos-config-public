{
  lib,
  config,
  customUtils,
  ...
}: {
  imports = customUtils.getImportable ./.;

  options.custom.selfhosting.enable = lib.mkEnableOption "enable selfhosting configuration";

  config = lib.mkIf config.custom.selfhosting.enable {
    services = {
      nextcloud.enable = false;
      jellyfin.enable = false;
    };
  };
}
