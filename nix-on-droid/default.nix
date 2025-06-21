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

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  environment.etcBackupExtension = ".ebak";
  system.stateVersion = "24.05";
  time.timeZone = "Europe/Warsaw";
  environment.motd = null;

  environment.packages = with pkgs; [
    vim
    killall
  ];

  android-integration = {
    am.enable = true;
    termux-open.enable = true;
    termux-open-url.enable = true;
    termux-reload-settings.enable = true;
    termux-setup-storage.enable = true;
    termux-wake-lock.enable = true;
    termux-wake-unlock.enable = true;
  };

  home-manager = {
    config = import paths.homeManagerConfig;
    extraSpecialArgs = {
      inherit lib inputs overlays paths;
      homeType = "droid";
    };
    backupFileExtension = "hbak";
  };
}
