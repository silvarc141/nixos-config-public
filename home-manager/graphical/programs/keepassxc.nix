{
  lib,
  config,
  ...
}: {
  config = lib.mkIf (config.programs.keepassxc.enable && config.custom.secrets.enable) {
    programs.keepassxc = {
      rootDirectory = ".local/share/passwords";
      autostart.openInitialDatabase = {
        enable = true;
      };
      integrations = {
        keyring.enable = true;
        sshAgent.enable = true;
        browser.enable = false;
      };
      sync = {
        enable = true;
        paths.rcloneToken = config.sops.secrets.rclone-token-password-database.path;
      };
      controlCommands.addToPath = true;
      extraSettings = {
        General = {
          UseAtomicSaves = false;
          BackupBeforeSave = true;
          BackupFilePathPattern = "backup/{TIME}-{DB_FILENAME}.kdbx";
        };
        Security = {
          ClearSearch = true;
          LockDatabaseIdle = false;
          ClearClipboard = false;
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
        PasswordGenerator = {
          AdvancedMode = true;
          Type = 1;
          Logograms = true;
          WordSeparator = "";
        };
      };
    };
    custom.graphical.desktopAgnostic.extraCommands = {
      passwordManagerOpen = lib.getExe config.programs.keepassxc.package;
      passwordManagerLock = lib.getExe config.programs.keepassxc.controlCommands.scripts.lock-all;
    };
    sops.secrets.rclone-token-password-database = {};
    custom.ephemeral = {
      data = {
        directories = [
          config.programs.keepassxc.rootDirectory
        ];
      };
      ignored = {
        files = [
          ".config/rclone/rclone.conf"
        ];
      };
    };
    wayland.windowManager.hyprland.settings.windowrulev2 = lib.mkIf config.wayland.windowManager.hyprland.enable [
      "float, class:^(org.keepassxc.KeePassXC)$, title:^(Unlock Database - KeePassXC)$"
      "pin, class:^(org.keepassxc.KeePassXC)$, title:^(Unlock Database - KeePassXC)$"
      "float, class:^(org.keepassxc.KeePassXC)$, title:^(KeePassXC -  Access Request)$"
      "pin, class:^(org.keepassxc.KeePassXC)$, title:^(KeePassXC -  Access Request)$"
    ];
  };
}
