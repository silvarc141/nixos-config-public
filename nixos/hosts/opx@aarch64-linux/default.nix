{
  lib,
  modulesPath,
  config,
  ...
}: let
  cfg = config.custom;
in {
  imports = ["${modulesPath}/profiles/minimal.nix"];

  nixpkgs.config.permittedInsecurePackages = ["olm-3.2.16"]; # why is this needed for boot?
  boot.kernelModules = ["autofs4"]; # needed for boot for some reason, probably impermanence -> try to get rid of this
  environment.persistence = lib.mkForce {};

  mobile.beautification = {
    silentBoot = false;
    splash = false;
  };

  custom = {
    mobile.enable = true;
    mainUser.homeType = "none";
  };

  users = {
    users.root.password = "givemeaccess";
    mutableUsers = true;
    users.${cfg.mainUser.name}.hashedPasswordFile = null;
  };

  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "yes";
  services.openssh.settings.PasswordAuthentication = true;
  networking.networkmanager.enable = lib.mkForce false;
  networking.wireless = {
    enable = true;
    networks = {
      mob.psk = "givemeinternet";
    };
  };
  networking.hostName = "opx";

  # Pingable at opx.local
  services.avahi = {
    openFirewall = true;
    nssmdns4 = true; # Allows software to use Avahi to resolve.
    enable = true;
    publish = {
      userServices = true;
      enable = true;
      addresses = true;
      workstation = true;
    };
  };
}
