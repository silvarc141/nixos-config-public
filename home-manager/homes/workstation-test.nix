{lib, ...}: {
  imports = [./workstation.nix];
  config = let
    inherit (lib) mkForce;
  in {
    custom.graphical.windowManager = mkForce "gnome";
  };
}
