{
  lib,
  config,
  pkgs,
  ...
}: {
  options.custom.virtualization.enable = lib.mkEnableOption "enable virtualization tools configuration";

  config = lib.mkIf config.custom.virtualization.enable {
    home.packages = with pkgs; [distrobox];

    custom.ephemeral = {
      large = {
        directories = [
          ".local/share/containers"
          ".config/VirtualBox"
        ];
      };
    };

    home.activation = lib.mkIf config.custom.ephemeral.enable {
      distroboxSetupFix = lib.hm.dag.entryAfter ["writeBoundary"] ''
        mkdir -p /persist/home/${config.home.username}/large/.local/share/containers
      '';
    };
  };
}
