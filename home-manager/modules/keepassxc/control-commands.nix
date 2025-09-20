{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.keepassxc;
in {
  options.programs.keepassxc = {
    controlCommands = let
      mkControlScriptOption = name: value:
        lib.mkOption {
          type = lib.types.package;
          default = pkgs.writeShellScriptBin "keepassxc-control-${name}" value;
          description = "KeePassXC ${name} control command written to a script. (usually no need to modify this)";
        };
    in {
      addToPath = lib.mkOption {
        type = lib.types.bool;
        description = "Make KeePassXC control command scripts available in path";
        default = false;
      };
      commands = lib.mkOption {
        type = with lib.types; attrsOf str;
        description = "KeePassXC control commands";
        default = {};
      };
      scripts = lib.mapAttrs mkControlScriptOption cfg.controlCommands.commands;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = lib.mkIf cfg.controlCommands.addToPath (builtins.attrValues cfg.controlCommands.scripts);
    programs.keepassxc.controlCommands.commands = let
      mkDbusCall = {
        service,
        object,
        interface ? service,
        signature ? "",
        method,
        args ? "",
      }: "${pkgs.systemd}/bin/busctl --user call ${service} ${object} ${interface} ${method} ${signature} ${args}";

      mkKeepassxcDbusCall = {
        method,
        signature ? "",
        args ? "",
      }:
        mkDbusCall {
          inherit method signature args;
          service = "org.keepassxc.KeePassXC.MainWindow";
          object = "/keepassxc";
        };
    in {
      lock-all = mkKeepassxcDbusCall {method = "lockAllDatabases";};
      open-initial-database = mkKeepassxcDbusCall {
        method = "openDatabase";
        signature = "s";
        args = "${config.home.homeDirectory}/${cfg.rootDirectory}/${cfg.databaseDirectory}/${cfg.autostart.openInitialDatabase.path}";
      };
      # Trigger a prettier unlock prompt used in keepassxc secret service (must be enabled)
      # Caveat: if prompt window is closed it will not trigger again until keepassxc restart
      pretty-unlock = let
        busctl = "${pkgs.systemd}/bin/busctl";
        cut = "${pkgs.coreutils}/bin/cut";
      in ''
        prompt=$(${busctl} --user call org.keepassxc.KeePassXC.MainWindow /org/freedesktop/secrets org.freedesktop.Secret.Service Unlock ao "1" "/org/freedesktop/secrets/collection/passwords" | ${cut} -d '"' -f2)
        ${busctl} --user call org.keepassxc.KeePassXC.MainWindow $prompt org.freedesktop.Secret.Prompt Prompt s "0"
        ${busctl} --user call org.keepassxc.KeePassXC.MainWindow $prompt org.freedesktop.Secret.Prompt Dismiss
      '';
    };
  };
}
