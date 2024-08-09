{
  outputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./sops.nix
    ./graphical
    ./boot.nix
    ./tty.nix
    ./usb.nix
    ./audio.nix
    ./bluetooth.nix
    ./lid.nix
    ./gpu.nix
    ./impermanence.nix
    ./trackpoint.nix
    ./fingerprint.nix
    ./single-user.nix
  ];

  system.stateVersion = "23.11";

  environment = {
    systemPackages = with pkgs; [vim];
    variables = {
      EDITOR = "vim";
      VISUAL = "vim";
    };
    shellAliases.l = null;
  };

  security.sudo.extraConfig = "Defaults lecture=\"never\"";

  time.timeZone = lib.mkDefault "Europe/Warsaw";
  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
    ];
  };

  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  networking.hostName = lib.mkDefault "nix";
  networking.networkmanager.enable = true;
  services.tailscale.enable = true;
  services.openssh.enable = true;
  # workaround slow boot network manager issue
  #systemd.services.systemd-udev-settle.enable = false;
  #systemd.services.NetworkManager-wait-online.enable = false;

  programs = {
    _1password.enable = true;
  };
}
