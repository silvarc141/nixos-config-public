{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.programs.zathura.enable {
    custom.graphical.defaultApps.pdfReader = "org.pwmt.zathura.desktop";
    xdg.desktopEntries."org.pwmt.zathura" = {
      name = "Zathura";
      type = "Application";
      noDisplay = true;
      exec = "zathura %U";
    };
    custom.ephemeral = {
      data = {
        directories = [
          ".local/share/zathura"
        ];
      };
    };
  };
}
