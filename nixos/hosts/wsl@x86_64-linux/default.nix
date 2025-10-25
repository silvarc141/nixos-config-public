{
  config,
  inputs,
  lib,
  ...
}: {
  imports = [inputs.nixos-wsl.nixosModules.default];

  custom = {
    mainUser = {
      name = "wslivarc";
      homeType = "wsl";
    };
  };

  wsl = {
    enable = true;
    wslConf = {
      automount.root = "/win";
      network.generateHosts = false;
      interop.appendWindowsPath = false;

      # force, otherwise defaults to "nixos"
      user.default = lib.mkForce config.custom.mainUser.name;
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  networking.dhcpcd.enable = false;
  boot.isContainer = true;
  environment.etc.hosts.enable = false;
  environment.etc."resolv.conf".enable = false;

  # Disable systemd units that don't make sense on WSL
  systemd.services."serial-getty@ttyS0".enable = false;
  systemd.services."serial-getty@hvc0".enable = false;
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@".enable = false;
  systemd.services.firewall.enable = false;
  systemd.services.systemd-resolved.enable = false;
  systemd.services.systemd-udevd.enable = false;

  # Don't allow emergency mode, because we don't have a console.
  systemd.enableEmergencyMode = false;
}
