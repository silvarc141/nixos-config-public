{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.programs.keepassxc;
in {
  options.programs.keepassxc = {
    sync = {
      enable = lib.mkEnableOption "systemd service for syncing KeePassXC databases";
      paths = {
        remote = lib.mkOption {
          type = lib.types.str;
          description = "Remote sync base directory";
          default = ":drive:";
        };
        local = lib.mkOption {
          type = lib.types.str;
          description = "Local sync base directory, relative to home";
          default = cfg.rootDirectory;
        };
        logFile = lib.mkOption {
          type = lib.types.str;
          description = "Sync log file, relative to KeePassXC root directory";
          default = "sync.log";
        };
        rcloneToken = lib.mkOption {
          type = lib.types.str;
          description = "Absolute path to rclone token file";
          default = "TODO";
        };
      };
      delayOnBoot = lib.mkOption {
        type = lib.types.str;
        default = "1min";
      };
      pollInterval = lib.mkOption {
        type = lib.types.str;
        default = "5min";
      };
    };
  };
  config = lib.mkIf cfg.sync.enable {
    programs.keepassxc.controlCommands.commands.sync = let
      localPathFull = "${config.home.homeDirectory}/${cfg.sync.paths.local}";
    in
      # sh
      ''
        rclone="${lib.getExe pkgs.rclone}"
        localDatabase="${localPathFull}/${cfg.databaseDirectory}"
        remoteDatabase="${cfg.sync.paths.remote}/${cfg.databaseDirectory}"
        localBackup="${localPathFull}/${cfg.backupDirectory}"
        remoteBackup="${cfg.sync.paths.remote}/${cfg.backupDirectory}"
        logFile="${localPathFull}/${cfg.sync.paths.logFile}"
        rcloneTokenFile="${cfg.sync.paths.rcloneToken}"

        echo "Creating local directories..."
        mkdir -p "$localDatabase"
        mkdir -p "$localBackup"

        echo "Ensuring remote directories exist..."
        $rclone mkdir "$remoteDatabase" \
          --verbose \
          --log-file="$logFile" \
          --drive-token "$(cat "$rcloneTokenFile")"

        $rclone mkdir "$remoteBackup" \
          --verbose \
          --log-file="$logFile" \
          --drive-token "$(cat "$rcloneTokenFile")"

        echo "Starting password database synchronization..."
        if ! $rclone bisync "$remoteDatabase" "$localDatabase" \
          --verbose \
          --log-file="$logFile" \
          --backup-dir1="$remoteBackup" \
          --backup-dir2="$localBackup" \
          --resilient \
          --recover \
          --max-lock=2m \
          --conflict-resolve=newer \
          --force \
          --drive-token "$(cat "$rcloneTokenFile")" \
          --drive-acknowledge-abuse=true \
          --drive-use-trash=false \
          --drive-skip-gdocs=true; then
        echo "Initial bisync failed, retrying with --resync" >> "$logFile"
        $rclone bisync "$remoteDatabase" "$localDatabase" \
          --verbose \
          --log-file="$logFile" \
          --backup-dir1="$remoteBackup" \
          --backup-dir2="$localBackup" \
          --resilient \
          --recover \
          --max-lock=2m \
          --conflict-resolve=newer \
          --force \
          --drive-token "$(cat "$rcloneTokenFile")" \
          --drive-acknowledge-abuse=true \
          --drive-use-trash=false \
          --drive-skip-gdocs=true \
          --resync
        fi

        echo "Password synchronization completed."
      '';
    systemd.user = {
      services.keepassxc-sync = {
        Service.ExecStart = lib.getExe cfg.controlCommands.scripts.sync;
      };
      timers.keepassxc-sync = {
        Timer = {
          OnBootSec = cfg.sync.delayOnBoot;
          OnUnitActiveSec = cfg.sync.pollInterval;
          Unit = "keepassxc-sync.service";
        };
        Install.WantedBy = ["timers.target"];
      };
    };
  };
}
