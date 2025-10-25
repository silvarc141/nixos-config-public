{
  config,
  lib,
  ...
}: {
  options.custom.graphical.defaultApps = let
    apps = [
      "textEditor"
      "imageViewer"
      "videoPlayer"
      "fileManager"
      "archiveManager"
      "pdfReader"
    ];
    mkDefaultAppOption = name:
      lib.mkOption {
        type = lib.types.str;
        default = '''';
      };
  in
    lib.genAttrs apps mkDefaultAppOption;

  config = let
    apps = config.custom.graphical.defaultApps;
  in
    lib.mkIf config.custom.graphical.enable {
      xdg.mime.enable = true;
      xdg.mimeApps = {
        enable = true;
        associations.added = {
          "text/*" = [apps.textEditor];
          "video/*" = [apps.videoPlayer];
          "image/*" = [apps.imageViewer];
          "inode/directory" = [apps.fileManager];
          "application/zip" = [apps.archiveManager];
          "application/pdf" = [apps.pdfReader];
        };
        defaultApplications = {
          "text/*" = [apps.textEditor];
          "video/*" = [apps.videoPlayer];
          "image/*" = [apps.imageViewer];
          "inode/directory" = [apps.fileManager];
          "application/zip" = [apps.archiveManager];
          "application/pdf" = [apps.pdfReader];
        };
      };
    };
}
