{
  pkgs,
  config,
  lib,
  ...
}: {
  options.custom.notes = let
    inherit (lib) mkEnableOption mkOption types;
  in {
    enable = mkEnableOption "enable notes configuration";
    location = mkOption {
      type = types.str;
      default = ".local/share/notes";
    };
    sync = {
      enable = mkEnableOption "enable notes synchronization service";
      remote = mkOption {
        type = types.str;
        default = "";
        example = "git@notes.git:silvarc141/notes.git";
      };
    };
  };

  config = lib.mkIf config.custom.notes.enable {
    systemd.user = lib.mkIf (config.custom.notes.sync.enable && config.custom.secrets.enable) {
      enable = true;
      services.sync-notes = {
        Service = {
          ExecStart = "${pkgs.writeShellScript "sync-notes" ''
            GIT=${pkgs.git}/bin/git

            NOTESDIR='${config.custom.notes.location}'
            if [ ! -d "$NOTESDIR" ]; then
              mkdir -p "$NOTESDIR"
            fi

            cd "$NOTESDIR"

            if [ ! -d ".git" ]; then
              $GIT init -b main
              $GIT remote add origin "${config.custom.notes.sync.remote}"
              if ! $GIT fetch; then
                rm -rf .git
                echo "Git fetch failed. Removing changes and exiting."
                exit 1
              fi
              $GIT checkout -b main origin/main --force
            fi

            $GIT add -A
            $GIT commit -m "${config.home.username}@$HOSTNAME"
            $GIT pull --rebase origin main --autostash
            $GIT push origin main
          ''}";
          Restart = "on-failure";
          RestartSec = 30;
        };
      };
      timers.sync-notes = {
        Timer = {
          OnBootSec = "1min";
          OnUnitActiveSec = "5min";
          Unit = "sync-notes.service";
        };
        Install.WantedBy = ["timers.target"];
      };
    };
  };
}
