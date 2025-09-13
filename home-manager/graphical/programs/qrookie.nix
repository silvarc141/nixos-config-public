{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: {
  options.programs.qrookie.enable = lib.mkEnableOption "QRookie Meta Quest app downloader";

  config = lib.mkIf config.programs.qrookie.enable {
    home.packages = [inputs.qrookie.packages.${pkgs.system}.default];
    custom.ephemeral.data.directories = [".local/share/QRookie"];
  };
}
