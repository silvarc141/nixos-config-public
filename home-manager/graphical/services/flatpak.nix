{
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.custom;
in {
  # imports = [inputs.nix-flatpak.homeManagerModules.nix-flatpak];

  options.services.flatpak.enable = lib.mkEnableOption "flatpak";

  config = lib.mkIf config.services.flatpak.enable {
    custom.ephemeral.local = lib.mkIf cfg.ephemeral.enable {
      directories = [
        ".local/share/flatpak"
      ];
    };
  };
}
