{
  config,
  lib,
  pkgs,
  ...
}: {
  options.programs.nautilus.enable = lib.mkEnableOption "nautilus file manager";

  config = lib.mkIf config.programs.nautilus.enable {
    custom.graphical.desktopAgnostic.extraCommands.fileManager = lib.getExe pkgs.nautilus;
    custom.graphical.defaultApps.fileManager = "nautilus.desktop";
    custom.graphical.defaultApps.archiveManager = "nautilus.desktop";

    home.packages = with pkgs; [nautilus];

    custom.ephemeral = {
      local = {
        directories = [
          ".local/share/nautilus/tags/meta.db"
        ];
      };
    };
  };
}
