{
  inputs,
  pkgs,
  hostName,
  overlays,
  paths,
  lib,
  ...
}: {
  imports = [(import (./. + "/hosts/${hostName}"))];

  system.stateVersion = "24.05";
  time.timeZone = "Europe/Warsaw";

  environment = {
    motd = null;
    etcBackupExtension = ".ebak";
    packages = with pkgs; [
      gnugrep
      pciutils
      usbutils
      inetutils
      e2fsprogs
      killall
      nmap
      neovim
    ];
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
      warn-dirty = false
    '';
    nixPath = [
      "nixpkgs=${inputs.nixpkgs-stable.outPath}"
    ];
    registry.nixpkgs.to = {
      type = "path";
      path = inputs.nixpkgs-stable.outPath;
    };
    substituters = [
      "https://cache.nixos.org/"
    ];
    trustedPublicKeys = [
      "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
    ];
  };

  android-integration = {
    am.enable = true;
    termux-open.enable = true;
    termux-open-url.enable = true;
    termux-reload-settings.enable = true;
    termux-setup-storage.enable = true;
    termux-wake-lock.enable = true;
    termux-wake-unlock.enable = true;
    xdg-open.enable = true;
  };

  home-manager = {
    config = import paths.homeManagerConfig;
    extraSpecialArgs = {
      inherit lib inputs overlays paths;
      homeType = "droid";
    };
    backupFileExtension = "hbak";
  };

  user.shell = "${pkgs.nushell}/bin/nu";

  terminal = {
    font = "${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMono/JetBrainsMonoNerdFont-Regular.ttf";
    colors = {
      background = "1e1e2e";
      foreground = "cdd6f4";

      color0 = "45475a";
      color8 = "585b70";

      color1 = "f38ba8";
      color9 = "f38ba8";

      color2 = "a6e3a1";
      color10 = "a6e3a1";

      color3 = "f9e2af";
      color11 = "f9e2af";

      color4 = "89b4fa";
      color12 = "89b4fa";

      color5 = "f5c2e7";
      color13 = "f5c2e7";

      color6 = "94e2d5";
      color14 = "94e2d5";

      color7 = "bac2de";
      color15 = "a6adc8";
    };
  };
}
