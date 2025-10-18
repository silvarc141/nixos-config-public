{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types;
  cfg = config.custom;
in {
  # These directories should be persisted outside of home manager which does not allow options other than symlink and bindfs which can cause problems in performance and compatibility.
  options.custom.home = {
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
    home.sessionVariables = let
      mkHomePath = path: "/home/${config.home.username}/${path}";
    in {
      XDG_DOWNLOAD_DIR = mkHomePath cfg.home.unsorted;
      XDG_DESKTOP_DIR = mkHomePath cfg.home.unsorted;
      XDG_DOCUMENTS_DIR = mkHomePath cfg.home.unsorted;
      XDG_PICTURES_DIR = mkHomePath cfg.home.media;
      XDG_MUSIC_DIR = mkHomePath cfg.home.media;
      XDG_VIDEOS_DIR = mkHomePath cfg.home.media;
    };

    systemd.user = {
      services.clear-unsorted-directory = {
        Service = {
          ExecStart = "${pkgs.writeShellScript "clear-unsorted-directory" ''
            HOME="/home/${config.home.username}"
            DATE=$(${pkgs.coreutils}/bin/date -d yesterday --iso-8601)
            ARCHIVE="$HOME/${cfg.home.archive}/$DATE"
            UNSORTED="$HOME/${cfg.home.unsorted}"

            mkdir -p $ARCHIVE
            if [ -n "$(ls -A $UNSORTED)" ]; then
              mv -f $UNSORTED/* $ARCHIVE/
            fi
          ''}";
          Restart = "on-failure";
          RestartSec = 30;
        };
      };
      timers.clear-unsorted-directory = {
        Timer = {
          OnCalendar = "*-*-* 05:30:00";
          Persistent = true;
        };
        Install.WantedBy = ["timers.target"];
      };
    };
  };
}
