{
  lib,
  pkgs,
  ...
}: {
  custom = {
    disko = {
      enable = true;
      deviceName = "/dev/sda";
      swapSize = "8G";
      storage = [{device = "/dev/sdb";}];
    };
    boot = {
      enable = true;
      fullDiskEncryption = {
        enable = true;
        unattendedDecryption.enable = true;
      };
    };
    tty.enable = true;
    ephemeral.enable = true;
    selfhosting.enable = true;
    remoteAccess.enable = true;
    mainUser = {
      homeType = "server";
    };
    # usb.enable = true; # disabled because of issues with devmon vs polkit
  };

  # enable when multiple-tailnet setup is easier to achieve
  services.tailscale.enable = false;

  boot.initrd.availableKernelModules = ["xhci_pci" "ehci_pci" "ahci" "usb_storage" "usbhid" "ums_realtek" "sd_mod" "sr_mod"];
  boot.kernelModules = ["kvm-intel"];
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = true;
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-vaapi-driver
      libva-utils
    ];
  };
}
