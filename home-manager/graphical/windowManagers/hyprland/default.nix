{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = lib.custom.getImportable ./.;

  options.wayland.windowManager.hyprland.mergeBind = lib.mkOption {
    type = with lib.types; listOf str;
    default = [];
  };

  config = lib.mkIf config.wayland.windowManager.hyprland.enable {
    custom = {
      ephemeral = {
        local.files = [".local/share/hyprland/lastVersion"];
        ignored.files = [".local/share/hyprland/lastNag"];
      };
      graphical.desktopAgnostic.extraCommands = let
        hyprctl = "${pkgs.hyprland}/bin/hyprctl";
      in {
        screenOn = "${hyprctl} dispatch dpms on";
        screenOff = "${hyprctl} dispatch dpms off";
      };
    };
    wayland.windowManager.hyprland.settings.bind = config.wayland.windowManager.hyprland.mergeBind;
  };
}
