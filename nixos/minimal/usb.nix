{
  lib,
  config,
  ...
}:
with lib; {
  options.custom.usb.enable = mkEnableOption "enable usb configuration";

  config = mkIf config.custom.usb.enable {
    services.devmon.enable = true;
    services.gvfs.enable = true;
    services.udisks2.enable = true;
  };
}
