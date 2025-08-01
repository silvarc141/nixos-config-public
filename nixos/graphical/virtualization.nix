{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.custom;
in {
  options.custom.graphical.virtualization.enable = mkEnableOption "enable virt configuration";

  config = mkIf cfg.graphical.virtualization.enable {
    virtualisation = {
      containers.enable = true;
      podman = {
        enable = true;
        dockerCompat = true;
      };
      virtualbox.host.enable = true;
    };

    users.extraGroups.vboxusers.members = ["${cfg.mainUser.name}"];

    environment.systemPackages = with pkgs; [
      podman-tui
      podman-compose
    ];

    # for cross compilation of mobile-nixos
    boot.binfmt.emulatedSystems = ["aarch64-linux"];
  };
}
