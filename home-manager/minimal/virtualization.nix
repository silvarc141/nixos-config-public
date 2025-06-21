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
          # ".local/share/containers/storage" cannot be a symlink
          ".local/share/containers"
        ];
      };
    };
  };
}
