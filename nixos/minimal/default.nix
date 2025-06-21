{
  pkgs,
  lib,
  config,
  overlays,
  ...
}: {
  imports = lib.custom.getImportable ./.;

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
      settings = {
        experimental-features = ["nix-command" "flakes"];
        warn-dirty = false;
        substituters = [
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
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
      source = "/home/${config.custom.mainUser.name}/nixos-config";
    };
  };
}
