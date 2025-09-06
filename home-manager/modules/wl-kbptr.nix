{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.wl-kbptr;
  format = pkgs.formats.ini {};
in {
  options.programs.wl-kbptr = {
    enable = lib.mkEnableOption "wl-kbptr pointer navigation";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.wl-kbptr;
      defaultText = lib.literalExpression "pkgs.wl-kbptr";
      description = "The package to use for wl-kbptr.";
    };

    settings = lib.mkOption {
      type = format.type;
      default = {};
      example = lib.literalExpression '''';
      description = ''
        Configuration written to
        {file}`$XDG_CONFIG_HOME/wl-kbptr/config`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [cfg.package];

    xdg.configFile."wl-kbptr/config" = lib.mkIf (cfg.settings != {}) {
      source = format.generate "wl-kbptr-config" cfg.settings;
    };
  };
}
