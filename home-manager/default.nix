{homeType ? "minimal", ...}: {
  imports = [
    ./modules
    ./minimal
    ./graphical
    (import (./. + "/homes/${homeType}.nix"))
  ];
}
