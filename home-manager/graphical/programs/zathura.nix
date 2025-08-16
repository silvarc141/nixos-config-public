{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.programs.zathura.enable {
    custom.graphical.defaultApps.pdfReader = "org.pwmt.zathura.desktop";
    xdg.desktopEntries."org.pwmt.zathura" = {
      # recreating the mime types is not needed as they are placed in separately created desktop entries
      name = "Zathura";
      noDisplay = true;
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
