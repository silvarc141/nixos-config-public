{inputs, ...}: {
  imports = [
    ./hardware-configuration.nix
    inputs.disko.nixosModules.default
    (import ./disko.nix {device = "/dev/nvme0n1";})
  ];

  capabilities = {
    boot.enable = true;
    tty.enable = true;
    lid.enable = true;
    bluetooth.enable = true;
    audio.enable = true;
    usb.enable = true;
    optInPersistence.enable = true;
    gpu.enable = true;
    graphical = {
      enable = true;
      gaming.enable = true;
      virt.enable = true;
      hyprland.enable = true;
    };
    singleUser = {
      enable = true;
      name = "silvarc";
    };
  };
}
