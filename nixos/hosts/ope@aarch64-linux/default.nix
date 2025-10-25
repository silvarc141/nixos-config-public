{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkForce;
  cfg = config.custom;
in {
  nixpkgs.config.permittedInsecurePackages = ["olm-3.2.16"];
  boot.kernelModules = ["autofs4"];
  environment.persistence = mkForce {};

  custom = {
    modem.enable = true;
    mobile.enable = true;
    remoteAccess.enable = true;
    mainUser.homeType = "none";
  };

  services.openssh.settings.PasswordAuthentication = true;

  mobile.beautification = {
    silentBoot = true;
    splash = true;
  };

  networking.hostName = "ope";

  # networking.networkmanager.ensureProfiles.profiles."plus-internet" = {
  #   connection = {
  #     id = "Plus Internet";
  #     type = "gsm";
  #     interface-name = "rmnet_ipa0";
  #     autoconnect = true;
  #   };
  #   gsm = {
  #     apn = "plus";
  #     ip-type = "ipv4";
  #   };
  #   ipv4 = {
  #     method = "auto";
  #   };
  #   ipv6 = {
  #     method = "disabled";
  #   };
  # };

  # try remove after testing
  users = {
    mutableUsers = true;
    users.${cfg.mainUser.name} = {
      isNormalUser = true;
      initialPassword = "givemeaccess";
      hashedPasswordFile = null;
      extraGroups = [
        "dialout"
        "feedbackd"
        "video"
        "networkmanager"
        "wheel"
      ];
    };
  };

  # try remove after testing
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };

  environment.systemPackages = with pkgs; [
    kitty
    epiphany
    modem-manager-gui
    chatty
    cheese
    # megapixels
  ];

  programs.calls.enable = true;

  services.xserver.desktopManager.phosh = {
    enable = true;
    user = cfg.mainUser.name;
    group = "users";
  };

  programs.dconf.enable = true;
  services.displayManager.gdm.enable = true;
  services.gnome.gnome-keyring.enable = true;

  hardware = {
    sensor.iio.enable = true;
    graphics.enable = true;
  };

  # zramSwap.enable = true; # what does this do?
}
