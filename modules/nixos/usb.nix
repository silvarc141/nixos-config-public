{
  lib,
  config,
  ...
}:
with lib; {
  options.capabilities.usb.enable = mkEnableOption "enable usb configuration";

  config = mkIf config.capabilities.usb.enable {
    services.devmon.enable = true;
    services.gvfs.enable = true;
    services.udisks2.enable = true;
  };
}
