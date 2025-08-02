{
  modulesPath,
  pkgs,
  ...
}: {
  imports = ["${modulesPath}/profiles/minimal.nix"];

  system.stateVersion = "25.11";
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true; # needed for firmware

  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "yes";
  services.openssh.settings.PasswordAuthentication = true;
  users.users.root.password = "givemeaccess";

  networking.networkmanager.enable = false;
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

  environment.systemPackages = with pkgs; [
    git
    vim
    curl
  ];
}
