{
  config,
  lib,
  ...
}: {
  options.custom.mobile.enable = lib.mkEnableOption "enable mobile configuration";

  config = lib.mkIf config.custom.mobile.enable {
    mobile.beautification = {
      silentBoot = lib.mkDefault false;
      splash = lib.mkDefault true;
    };
  };
}
