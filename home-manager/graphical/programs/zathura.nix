{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.programs.zathura.enable {
    custom.graphical.defaultApps.pdfReader = "org.pwmt.zathura.desktop";
    custom.ephemeral = {
      data = {
        directories = [
          ".local/share/zathura"
        ];
      };
    };
  };
}
