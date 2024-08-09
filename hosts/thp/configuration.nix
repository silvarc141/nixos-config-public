{inputs, ...}: {
  imports = [
    ./hardware-configuration.nix
    #inputs.disko.nixosModules.default
    #(import ./disko.nix {device = "/dev/nvme0n1";})
  ];

  capabilities = {
    boot.enable = true;
    tty.enable = true;
    lid.enable = true;
    bluetooth.enable = true;
    audio.enable = true;
    usb.enable = true;
    graphical = {
      enable = true;
    };
    singleUser = {
      enable = true;
      name = "silvarc";
    };
  };
}
