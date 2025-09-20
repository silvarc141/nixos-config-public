{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf getExe optionals;
in {
  config = mkIf config.wayland.windowManager.hyprland.enable {
    wayland.windowManager.hyprland = {
      settings = {
        ecosystem.enforce_permissions = lib.mkDefault true;
        permission =
          [
            # ".*, plugin, deny"

            ".xdg-desktop-portal-hyprland-wrapped, screencopy, allow"
            "${getExe config.wayland.windowManager.hyprland.finalPortalPackage}, screencopy, allow"

            # can this be safer?
            "${getExe pkgs.grim}, screencopy, allow"
          ]
          ++ optionals config.programs.wl-kbptr.enable [
            "${getExe pkgs.wl-kbptr}, screencopy, allow"
          ]
          ++ optionals config.programs.hyprlock.enable [
            "${getExe pkgs.hyprlock}, screencopy, allow"
          ];
      };
    };
  };
}
