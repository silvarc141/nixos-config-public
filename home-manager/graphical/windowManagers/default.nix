{
  lib,
  config,
  ...
}: let
  cfg = config.custom;
in {
  imports = lib.custom.getImportable ./.;

  options.custom.graphical = {
    windowManager = lib.mkOption {
      type = lib.types.enum ["hyprland" "niri"];
      default = "hyprland";
    };
  };

  config = {
    wayland.windowManager.hyprland.enable = lib.mkIf (cfg.graphical.windowManager == "hyprland") true;
    programs.niri.enable = lib.mkIf (cfg.graphical.windowManager == "niri") true;
  };
}
