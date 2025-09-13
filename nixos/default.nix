{
  hostName,
  arch,
  lib,
  ...
}: {
  imports = [
    ./minimal
    ./graphical
    ./selfhosting
    (import (./. + "/hosts/${hostName}@${arch}"))
  ];
  networking.hostName = hostName;
  system.stateVersion = "23.11";
  hardware.enableAllFirmware = true;
  time.timeZone = lib.mkDefault "Europe/Warsaw";
  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
}
