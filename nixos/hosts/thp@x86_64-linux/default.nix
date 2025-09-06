{lib, ...}: {
  custom = {
    disko = {
      enable = true;
      deviceName = "/dev/sda";
      swapSize = "8G";
    };
    boot = {
      enable = true;
      fullDiskEncryption.enable = true;
      hibernation = {
        enable = true;
        offset = 533760;
      };
      secureBoot.enable = false;
    };
    tty.enable = true;
    bluetooth.enable = true;
    audio.enable = true;
    usb.enable = true;
    lid.enable = true;
    ephemeral.enable = true;
    mainUser = {
      hasSecretsAccess = true;
      homeType = "workstation-travel";
    };
    graphical = {
      enable = true;
      windowManager = "hyprland";
    };
    workstation = {
      audio.enable = true;
    };
  };
  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "sd_mod" "rtsx_pci_sdmmc"];
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = true;

  services.fwupd.enable = true;

  # disable trackpoint
  services.udev.extraRules = ''
    # ALPS ThinkPad TrackPoint: Ignore as input device
    ATTRS{name}=="*TPPS/2 IBM TrackPoint", ENV{ID_INPUT}="", ENV{ID_INPUT_MOUSE}="", ENV{ID_INPUT_POINTINGSTICK}=""
  '';

  # libfprint-2-tod1-vfs0090 is broken
  # services.fprintd = {
  #   enable = true;
  #   tod.enable = true;
  #   tod.driver = pkgs.libfprint-2-tod1-vfs0090;
  # };
}
