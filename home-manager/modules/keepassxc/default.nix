{
  config,
  lib,
  pkgs,
  customUtils,
  ...
}: {
  imports = [
    ./sync.nix
    ./control-commands.nix
  ];
  options.programs.keepassxc = {
    rootDirectory = lib.mkOption {
      type = lib.types.str;
      description = "Path to KeePassXC root storage directory, relative to home. Used for sync, initial database etc.";
      default = "KeePassXC";
    };

    databaseDirectory = lib.mkOption {
      type = lib.types.str;
      description = "Path to KeePassXC database directory relative to KeePassXC root directory. Used for sync, initial database etc.";
      default = "database";
    };

    backupDirectory = lib.mkOption {
      type = with lib.types; nullOr str;
      description = "Path to KeePassXC backup directory relative to KeePassXC root directory. Used for sync backup, on-write backup etc. Set to null to disable backup.";
      default = "backup";
    };

    autostart = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to enable systemd service for starting KeePassXC";
      };
      openInitialDatabase = {
        enable = lib.mkEnableOption "opening database on KeePassXC start";
        path = lib.mkOption {
          type = lib.types.str;
          description = "Path to initial database, relative to database directory";
          default = "passwords.kdbx";
        };
      };
    };

    integrations = {
      sshAgent.enable = lib.mkEnableOption "ssh agent integration";
      keyring.enable = lib.mkEnableOption "freedesktop keyring integration";
      browser.enable = lib.mkEnableOption "browser integration";
    };

    prompt = {
      ssh = {
        enable = lib.mkEnableOption "prompt for KeePassXC database password on ssh connection";
        match = lib.mkOption {
          type = lib.types.str;
          description = "SSH hostname match for prompt";
          default = "*";
        };
      };
    };

    extraSettings = lib.mkOption {
      type = lib.types.attrs;
      default = {
        General = {
          UseAtomicSaves = false;
          BackupBeforeSave = true;
          BackupFilePathPattern = "backup/{TIME}-{DB_FILENAME}.kdbx";
        };
        Security = {
          LockDatabaseIdle = true;
          ClearSearch = true;
        };
        GUI = {
          ApplicationTheme = "classic";
          HideMenubar = true;
          CompactMode = true;
          HidePreviewPanel = false;
          HideToolbar = false;
          ShowTrayIcon = true;
          TrayIconAppearance = "monochrome-light";
        };
      };
      example = lib.literalExpression ''
        {
          General = {
            UseAtomicSaves = false;
            BackupBeforeSave = true;
            BackupFilePathPattern = "{TIME}-{DB_FILENAME}-backup.kdbx";
          };
          Security = {
            ClearClipboardTimeout = 9;
            ClearSearch = true;
            ClearSearchTimeout = 3;
            LockDatabaseIdle = true;
            LockDatabaseIdleSeconds = 300;
          };
          GUI = {
            ApplicationTheme = "classic";
            CompactMode = true;
            HideMenubar = true;
            HidePreviewPanel = false;
            HideToolbar = false;
            MinimizeOnClose = true;
            MinimizeOnStartup = true;
            ShowTrayIcon = true;
            TrayIconAppearance = "monochrome-light";
          };
          PasswordGenerator = {
            AdvancedMode = true;
            Type = 1;
            Logograms = true;
            WordSeparator = "";
          };
        }
      '';
      description = ''
        Additional configuration overlay, written to {file}`$XDG_CONFIG_HOME/keepassxc/keepassxc.ini`.
        See <https://github.com/keepassxreboot/keepassxc/blob/647272e9c5542297d3fcf6502e6173c96f12a9a0/src/core/Config.cpp#L49-L223>
        for the full list of options.
      '';
    };
  };

  config = let
    cfg = config.programs.keepassxc;
    sshKeepassxcPrompt = pkgs.writeShellScriptBin "ssh-keepassxc-prompt" ''
      until ssh-add -l &> /dev/null
      do
        echo "Waiting for agent. Please unlock the database."
        keepassxc &> /dev/null
        sleep 1
      done
      "${pkgs.libressl.nc}/bin/nc" "$1" "$2"
    '';
  in
    lib.mkIf cfg.enable {
      programs.ssh = lib.mkIf cfg.prompt.ssh.enable {
        matchBlocks.${cfg.prompt.ssh.match}.proxyCommand = "${sshKeepassxcPrompt}/bin/ssh-keepassxc-prompt %h %p";
      };

      services.gnome-keyring.enable = lib.mkIf cfg.integrations.keyring.enable false;

      programs.keepassxc.settings = builtins.foldl' (acc: elem: lib.recursiveUpdate acc elem) {} [
        {General.ConfigVersion = 2;}
        cfg.extraSettings
        (lib.optionalAttrs cfg.integrations.keyring.enable {FdoSecrets.Enabled = true;})
        (lib.optionalAttrs cfg.integrations.sshAgent.enable {SSHAgent.Enabled = true;})
        (lib.optionalAttrs cfg.integrations.browser.enable {Browser.Enabled = true;})
        (lib.optionalAttrs (cfg.backupDirectory != null) {
          General = {
            BackupBeforeSave = true;
            BackupFilePathPattern = "../${cfg.backupDirectory}/{TIME}-{DB_FILENAME}-on-write-backup.kdbx";
          };
        })
        (lib.optionalAttrs cfg.autostart.enable {
          GUI = {
            MinimizeOnClose = true;
            MinimizeOnStartup = true;
          };
        })
      ];

      systemd.user.services = {
        keepassxc = customUtils.mkTrayService {
          command = lib.getExe cfg.package;
          description = "KeePassXC password manager";
          settings = {
            Service.Environment = [
              ''"SSH_AUTH_SOCK=/run/user/1000/ssh-agent"''
              ''"QT_QPA_PLATFORM=wayland"''
            ];
          };
        };
        keepassxc-open-initial-database = lib.mkIf (cfg.autostart.enable && cfg.autostart.openInitialDatabase.enable) {
          Unit = {
            Description = "KeePassXC password manager: open initial database on startup";
            # After = ["keepassxc.service"];
            PartOf = ["graphical-session.target"];
          };
          Service = {
            # HACK: wait for keepassxc to initialize
            ExecStartPre = "${pkgs.coreutils}/bin/sleep 3";
            ExecStart = lib.getExe cfg.controlCommands.scripts.open-initial-database;
            Restart = "on-failure";
          };
          Install.WantedBy = ["graphical-session.target"];
        };
      };
    };
}
