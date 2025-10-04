{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.custom;
in {
  options.programs.qbittorrent.enable = lib.mkEnableOption "qBittorrent torrent client";

  config = lib.mkIf config.programs.qbittorrent.enable {
    home.packages = with pkgs; [qbittorrent];

    custom.ephemeral = {
      data = {
        directories = [
          ".config/qBittorrent"
        ];
      };
      local = {
        directories = [
          ".local/share/qBittorrent"
        ];
      };
    };
  };
}
