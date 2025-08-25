{
  pkgs,
  lib,
  config,
  ...
}: let
  tomlFormat = pkgs.formats.toml {};
in {
  config = lib.mkIf config.services.activitywatch.enable {
    custom.ephemeral.data = {
      directories = [".local/share/activitywatch"];
    };

    services.activitywatch = {
      settings = {
        port = 5600;
      };
    };

    systemd.user.services.awatcher = {
      Unit = {
        Description = "AWatcher";
        Requires = ["activitywatch.target"];
        After = ["activitywatch.target"];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.awatcher}/bin/awatcher";
        Restart = "always";
        RestartSec = 5;
      };
      Install.WantedBy = ["graphical-session.target"];
    };

    xdg.configFile."awatcher/config.toml".source = tomlFormat.generate "awatcher-config" {
      awatcher = {
        idle-timeout-seconds = 180;
        poll-time-idle-seconds = 4;
        poll-time-window-seconds = 1;
        # filters = {
        #   match-title = ".*keepass.*";
        # };
      };
    };
  };
}
