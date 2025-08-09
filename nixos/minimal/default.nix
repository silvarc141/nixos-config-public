{
  inputs,
  pkgs,
  lib,
  config,
  overlays,
  customUtils,
  ...
}: {
  imports = customUtils.getImportable ./.;

  config = {
    system.stateVersion = "23.11";
    hardware.enableAllFirmware = true;

    nixpkgs = {
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
      overlays = overlays;
    };

    nix = {
      channel.enable = false;
      registry = {
        np.flake = inputs.nixpkgs-stable;
        npu.flake = inputs.nixpkgs-unstable;
      };
      settings = {
        trusted-users = ["@wheel" "root"];
        experimental-features = ["nix-command" "flakes"];
        warn-dirty = false;
        substituters = [
          "https://cache.nixos.org/"
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
          "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
    };
    time.timeZone = lib.mkDefault "Europe/Warsaw";
    i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";

    environment = {
      systemPackages = with pkgs; [
        git
        curl
        wget
        pciutils
        usbutils
        inetutils
        e2fsprogs
        killall
        nmap
        neovim
      ];
      variables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
      shellAliases.l = null;
    };

    environment.etc.nixos = {
      enable = true;
      source = "/home/${config.custom.mainUser.name}/nixos";
    };
  };
}
