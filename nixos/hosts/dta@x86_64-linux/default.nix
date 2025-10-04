{
  lib,
  config,
  pkgs,
  ...
}: {
  custom = {
    disko = {
      enable = true;
      deviceName = "/dev/nvme0n1";
      swapSize = "36G";
    };
    boot = {
      enable = true;
      fullDiskEncryption = {
        enable = true;
        unattendedDecryption.enable = true;
      };
      secureBoot.enable = true;
    };
    tty.enable = true;
    bluetooth.enable = true;
    audio.enable = true;
    usb.enable = true;
    lid.enable = true;
    ephemeral.enable = true;
    graphical = {
      enable = true;
      windowManager = "hyprland";
      gaming.enable = true;
      virtualization.enable = true;
      waydroid.enable = true;
    };
    mainUser = {
      hasSecretsAccess = true;
      homeType = "workstation";
    };
    workstation = {
      audio.enable = true;
      unity.enable = true;
      sambaMount.enable = true;
      configSymlink.enable = true;
    };
  };
  services.ratbagd.enable = true;
  programs.gamescope.args = ["-F nis"];
  environment.systemPackages = with pkgs; [
    nvtopPackages.nvidia
    nvtopPackages.intel
    libva-utils
    piper
  ];
  environment.variables = lib.mkIf config.custom.graphical.wayland.enable {
    LIBVA_DRIVER_NAME = "nvidia";

    # required for nvidia on wayland
    GBM_BACKEND = "nvidia-drm";

    # make sure to not run nouveau
    GLX_VENDOR_LIBRARY_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };
  boot = {
    initrd = {
      availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
      kernelModules = [];
    };
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];
  };
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = "x86_64-linux";
  services.xserver.videoDrivers = ["nvidia"];
  hardware = {
    cpu.intel.updateMicrocode = true;
    nvidia = {
      modesetting.enable = true;
      open = false;
    };
  };
}
