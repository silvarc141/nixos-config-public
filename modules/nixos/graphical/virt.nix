{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  options.capabilities.graphical.virt.enable = mkEnableOption "enable virt configuration";

  config = mkIf config.capabilities.graphical.virt.enable {
    virtualisation = {
      containers.enable = true;
      podman = {
        enable = true;
        dockerCompat = true;
      };
      virtualbox.host.enable = true;
    };

    users.extraGroups.vboxusers.members = ["${config.capabilities.singleUser.name}"];

    environment.systemPackages = with pkgs; [
      podman-tui
      podman-compose
    ];
  };
}
