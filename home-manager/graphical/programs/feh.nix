{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.programs.feh.enable {
    custom.graphical.defaultApps.imageViewer = "feh.desktop";
    xdg.desktopEntries = {
      feh = {
        noDisplay = true;
        name = "feh";
        genericName = "Image Viewer";
        exec = "feh --scale-down";
        terminal = false;
        categories = ["Graphics" "2DGraphics"];
        mimeType = [
          "image/bmp"
          "image/g3fax"
          "image/gif"
          "image/x-fits"
          "image/x-pcx"
          "image/x-portable-anymap"
          "image/x-portable-bitmap"
          "image/x-portable-graymap"
          "image/x-portable-pixmap"
          "image/x-psd"
          "image/x-sgi"
          "image/x-tga"
          "image/x-xbitmap"
          "image/x-xwindowdump"
          "image/x-xcf"
          "image/x-compressed-xcf"
          "image/x-gimp-gbr"
          "image/x-gimp-pat"
          "image/x-gimp-gih"
          "image/x-sun-raster"
          "image/tiff"
          "image/jpeg"
          "image/x-psp"
          "application/postscript"
          "image/png"
          "image/x-icon"
          "image/x-xpixmap"
          "image/x-exr"
          "image/webp"
          "image/x-webp"
          "image/heif"
          "image/heic"
          "image/avif"
          "image/jxl"
          "image/svg+xml"
          "application/pdf"
          "image/x-wmf"
          "image/jp2"
          "image/x-xcursor"
        ];
      };
    };
  };
}
