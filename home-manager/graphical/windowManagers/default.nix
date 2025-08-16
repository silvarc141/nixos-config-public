{
  lib,
  config,
  customUtils,
  ...
}: let
  cfg = config.custom;
in {
  imports = customUtils.getImportable ./.;

  options.custom.graphical = {
    windowManager = lib.mkOption {
      type = lib.types.enum ["hyprland" "niri" "gnome"];
      default = "hyprland";
    };
  };

  config = lib.mkIf config.custom.graphical.enable {
    wayland.windowManager.hyprland.enable = lib.mkIf (cfg.graphical.windowManager == "hyprland") true;
    programs.niri.enable = lib.mkIf (cfg.graphical.windowManager == "niri") true;
  };
}
