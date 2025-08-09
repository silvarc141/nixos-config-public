{
  pkgs,
  lib,
  ...
}: let
  username = "silvarc";
in {
  system.stateVersion = "25.11";
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true; # needed for firmware
  nixpkgs.config.permittedInsecurePackages = ["olm-3.2.16"];

  mobile.beautification = {
    silentBoot = lib.mkDefault true;
    splash = lib.mkDefault true;
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="net", ENV{ID_NET_DRIVER}=="ipa", ENV{ID_MM_IP_METHOD}="passthrough"
  '';

  networking.hostName = "ope";

  networking.networkmanager.ensureProfiles.profiles."plus-internet" = {
    connection = {
      id = "Plus Internet";
      type = "gsm";
      interface-name = "rmnet_ipa0";
      autoconnect = true;
    };
    gsm = {
      apn = "plus";
      ip-type = "ipv4v6";
    };
    ipv4 = {
      method = "auto";
    };
    ipv6 = {
      method = "disabled";
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };

  users = {
    mutableUsers = true;
    users.${username} = {
      isNormalUser = true;
      initialPassword = "givemeaccess";
      extraGroups = [
        "dialout"
        "feedbackd"
        "video"
        "networkmanager"
        "wheel"
      ];
    };
  };

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
    git
    vim
    curl
    pciutils
    usbutils
    inetutils
    e2fsprogs
    killall
    nmap
    neovim

    kitty
    chatty
    megapixels
    epiphany
  ];

  programs.calls.enable = true;

  services.xserver.desktopManager.phosh = {
    enable = true;
    user = username;
    group = "users";
  };

  programs.dconf.enable = true;
  services.displayManager.gdm.enable = true;
  services.gnome.gnome-keyring.enable = true;

  hardware = {
    sensor.iio.enable = true;
    graphics.enable = true;
  };
}
