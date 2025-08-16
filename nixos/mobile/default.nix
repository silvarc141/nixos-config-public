{
  config,
  lib,
  ...
}: {
  options.custom.mobile.enable = lib.mkEnableOption "enable mobile configuration";

  config = lib.mkIf config.custom.mobile.enable {
    mobile.beautification = {
      silentBoot = false;
      splash = lib.mkDefault true;
    };
  };
}
