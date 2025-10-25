{
  config,
  lib,
  pkgs,
  ...
}: {
  options.programs.xarchiver.enable = lib.mkEnableOption "xarchiver archive manager";

  config = lib.mkIf config.programs.xarchiver.enable {
    custom.graphical.defaultApps.archiveManager = "xarchiver.desktop";
    home.packages = [pkgs.xarchiver];
    xdg.desktopEntries.xarchiver = {
      noDisplay = true;
      type = "Application";
      name = "Xarchiver";
      exec = "xarchiver %f";
      mimeType = [
        "application/epub+zip"
        "application/gzip"
        "application/java-archive"
        "application/vnd.android.package-archive"
        "application/vnd.appimage"
        "application/vnd.comicbook-rar"
        "application/vnd.comicbook+zip"
        "application/vnd.debian.binary-package"
        "application/vnd.efi.iso"
        "application/vnd.ms-cab-compressed"
        "application/vnd.ms-htmlhelp"
        "application/vnd.oasis.opendocument.text"
        "application/vnd.openofficeorg.extension"
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        "application/vnd.rar"
        "application/vnd.snap"
        "application/vnd.squashfs"
        "application/x-7z-compressed"
        "application/x-archive"
        "application/x-arj"
        "application/x-bzip"
        "application/x-bzip-compressed-tar"
        "application/x-bzip1"
        "application/x-bzip1-compressed-tar"
        "application/x-bzip2"
        "application/x-bzip2-compressed-tar"
        "application/x-bzip3"
        "application/x-bzip3-compressed-tar"
        "application/x-cb7"
        "application/x-cbt"
        "application/x-cd-image"
        "application/x-compress"
        "application/x-compressed-tar"
        "application/x-cpio"
        "application/x-cpio-compressed"
        "application/x-java-archive"
        "application/x-lha"
        "application/x-lrzip"
        "application/x-lrzip-compressed-tar"
        "application/x-lz4"
        "application/x-lz4-compressed-tar"
        "application/x-lzip"
        "application/x-lzip-compressed-tar"
        "application/x-lzma"
        "application/x-lzma-compressed-tar"
        "application/x-lzop"
        "application/x-rar"
        "application/x-rpm"
        "application/x-rzip"
        "application/x-rzip-compressed-tar"
        "application/x-source-rpm"
        "application/x-tar"
        "application/x-tarz"
        "application/x-tzo"
        "application/x-xpinstall"
        "application/x-xz"
        "application/x-xz-compressed-tar"
        "application/x-zip-compressed-fb2"
        "application/x-zpaq"
        "application/x-zstd-compressed-tar"
        "application/zip"
        "application/zstd"
      ];
    };
  };
}
