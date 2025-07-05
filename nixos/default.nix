{hostName, ...}: {
  imports = [
    ./minimal
    ./graphical
    ./selfhosting
    (import (./. + "/hosts/${hostName}"))
  ];
  networking.hostName = hostName;
}
