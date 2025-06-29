{
  lib,
  pkgs,
  ...
}: {
  custom = {
    boot = {
      enable = true;
      hibernation = {
        enable = true;
        offset = 533760;
      };
      fullDiskEncryption.enable = true;
      secureBoot.enable = true;
    };
    disko = {
      deviceName = "/dev/sda";
      swapSize = "8G";
    };
    tty.enable = true;
    bluetooth.enable = true;
    audio.enable = true;
    usb.enable = true;
    lid.enable = true;
    ephemeral.enable = true;
    graphical.enable = true;
    mainUser = {
      hasSecretsAccess = true;
      homeType = "workstation";
    };
  };
  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "sd_mod" "rtsx_pci_sdmmc"];
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = true;

  services.fwupd.enable = true;
  services.fprintd = {
    enable = true;
    tod.enable = true;
    tod.driver = pkgs.libfprint-2-tod1-vfs0090;
  };

  # disable trackpoint
  services.udev.extraRules = ''
    # ALPS ThinkPad TrackPoint: Ignore as input device
    ATTRS{name}=="*TPPS/2 IBM TrackPoint", ENV{ID_INPUT}="", ENV{ID_INPUT_MOUSE}="", ENV{ID_INPUT_POINTINGSTICK}=""
  '';
}
