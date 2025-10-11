{
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf config.custom.graphical.enable {
    services.greetd = {
      settings = {
        initial_session = lib.mkIf config.custom.boot.fullDiskEncryption.enable {
          user = config.custom.mainUser.name;
          command = config.custom.graphical.sessionCommand;
        };
        default_session.command = ''
          ${pkgs.greetd.tuigreet}/bin/tuigreet \
            --remember \
            --remember-session \
            --asterisks \
            --asterisks-char=# \
            --theme "border=darkgray;text=gray;prompt=gray;action=darkgray;button=gray;container=black;input=gray"
        '';
      };
    };
  };
}
