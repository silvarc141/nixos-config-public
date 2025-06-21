{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkOption mkEnableOption types;
  format = pkgs.formats.javaProperties {};
  cfg = config.programs.termux;
in {
  options.programs.termux = {
    enable = mkEnableOption "Termux environment configuration";
    settings = mkOption {
      type = types.attrs;
      description = ''
        Existing Termux properties may be found here:
        https://raw.githubusercontent.com/termux/termux-tools/refs/heads/master/termux.properties
      '';
      default = {
        fullscreen = true;
        bell-character = "ignore";
        extra-keys = [
          "ESC"
          "TAB"
          {
            key = "CTRL";
            popup = "ALT";
          }
          {
            key = "DOWN";
            popup = "UP";
          }
        ];
      };
    };
  };
  config = {
    xdg.configFile = {
      ".termux/termux.properties" = lib.mkIf (cfg.settings != {}) {
        text = format.generate "termux.properties" cfg.settings;
      };
    };
  };
}
