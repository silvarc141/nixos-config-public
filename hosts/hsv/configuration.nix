{...}: {
  imports = [./hardware-configuration.nix];

  capabilities = {
    boot.enable = true;
    tty.enable = true;
    usb.enable = true;
    impermanence.enable = true;
    singleUser = {
      enable = true;
      name = "silvarc";
    };
  };
}
