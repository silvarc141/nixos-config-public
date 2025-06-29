{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.kando;
in {
  options.programs.kando = {
    enable = lib.mkEnableOption "Kando pie menu";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.kando;
      defaultText = lib.literalExpression "pkgs.kando";
      description = "The package to use for kando.";
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      example = lib.literalExpression '''';
      description = ''
        Configuration written to
        {file}`$XDG_CONFIG_HOME/kando/config.json`.
      '';
    };

    menus = lib.mkOption {
      type = with lib.types; listOf attrs;
      default = {};
      example = lib.literalExpression '''';
      description = ''
        Configuration written to
        {file}`$XDG_CONFIG_HOME/kando/menus.json`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [cfg.package];

    systemd.user.services.kando = lib.custom.mkTrayService {
      command = lib.getExe pkgs.kando;
      description = "Kando radial menu";
      settings = {Service.Environment = "NIXOS_OZONE_WL=1";};
    };

    xdg.configFile = {
      "kando/config.json" = lib.mkIf (cfg.settings != {}) {
        text = builtins.toJSON cfg.settings;
      };
      "kando/menus.json" = let
        merged = {
          menus = cfg.menus;
          templates = [];
        };
      in
        lib.mkIf (cfg.menus != {}) {
          text = builtins.toJSON merged;
        };
    };
  };
}
