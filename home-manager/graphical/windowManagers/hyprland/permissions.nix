{
  lib,
  config,
  pkgs,
  ...
}: {
  config = lib.mkIf config.wayland.windowManager.hyprland.enable {
    wayland.windowManager.hyprland = {
      settings = {
        ecosystem.enforce_permissions = "true";
        permission =
          [
            # ".*, plugin, deny"
            "${lib.getExe config.wayland.windowManager.hyprland.finalPortalPackage}, screencopy, allow"
            "${lib.getExe pkgs.grim}, screencopy, allow"
          ]
          ++ lib.optionals config.programs.wl-kbptr.enable [
            "${lib.getExe pkgs.wl-kbptr}, screencopy, allow"
          ];
      };
    };
  };
}
