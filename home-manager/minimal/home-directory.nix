{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom;
in {
  # These directories should be persisted outside of home manager which does not allow options other than symlink and bindfs which can cause problems in performance and compatibility.
  options.custom.home = with lib; {
    enable = mkEnableOption "home directories configuration";
    unsorted = mkOption {
      type = types.str;
      readOnly = true;
      description = "directory for downloads, new files and ad-hoc operations, archived daily";
      default = "unsorted";
    };
    archive = mkOption {
      type = types.str;
      readOnly = true;
      description = "directory for storing archived unsorted content";
      default = "archive";
    };
    incubator = mkOption {
      type = types.str;
      readOnly = true;
      description = "directory for bigger experiments and not fully formed, early projects";
      default = "incubator";
    };
    projects = mkOption {
      type = types.str;
      readOnly = true;
      description = "directory for explicitly defined projects";
      default = "projects";
    };
    media = mkOption {
      type = types.str;
      readOnly = true;
      description = "directory for large files and media files";
      default = "media";
    };
  };

  config = lib.mkIf cfg.home.enable {
    home.sessionVariables = {
      XDG_DOWNLOAD_DIR = cfg.home.unsorted;
      XDG_DESKTOP_DIR = cfg.home.unsorted;
      XDG_DOCUMENTS_DIR = cfg.home.unsorted;
      XDG_PICTURES_DIR = cfg.home.media;
      XDG_MUSIC_DIR = cfg.home.media;
      XDG_VIDEOS_DIR = cfg.home.media;
    };

    systemd.user = {
      services.clear-unsorted-directory = {
        Service = {
          ExecStart = "${pkgs.writeShellScript "clear-unsorted-directory" ''
            HOME="/home/${config.home.username}"
            DATE=$(${pkgs.coreutils}/bin/date -d yesterday --iso-8601)
            ARCHIVE="$HOME/${cfg.home.archive}/$DATE/"
            mkdir -p $ARCHIVE
            mv -f $HOME/${cfg.home.unsorted}/* $ARCHIVE
          ''}";
          Restart = "on-failure";
          RestartSec = 30;
        };
      };
      timers.clear-unsorted-directory = {
        Timer.OnCalendar = "*-*-* 05:30:00";
        Install.WantedBy = ["timers.target"];
      };
    };
  };
}
