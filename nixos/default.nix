{
  hostName,
  arch,
  ...
}: {
  imports = [
    ./minimal
    ./graphical
    ./selfhosting
    (import (./. + "/hosts/${hostName}@${arch}"))
  ];
  networking.hostName = hostName;
}
