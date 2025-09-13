{
  config,
  lib,
  pkgs,
  customUtils,
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
      description = "The package to use for Kando.";
    };

    customIconThemePaths = lib.mkOption {
      type = with lib.types; attrsOf str;
      default = {};
      example = ''
        {
          papirus-dark = "$${config.gtk.iconTheme.package}/share/icons/Papirus-Dark/64x64/apps";
        }
      '';
    };

    useWayland = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Add environment variables to the Kando service that suggest electron to use native Wayland instead of XWayland.";
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
      default = [];
      example = lib.literalExpression '''';
      description = ''
        Configuration written to
        {file}`$XDG_CONFIG_HOME/kando/menus.json`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [cfg.package];

    systemd.user.services.kando = customUtils.mkTrayService {
      command = lib.getExe pkgs.kando;
      description = "Kando radial menu";
      settings = {
        Service.Environment = lib.mkIf cfg.useWayland [
          "NIXOS_OZONE_WL=1"
          "XDG_SESSION_TYPE=wayland"
        ];
      };
    };

    xdg.configFile = (
      {
        "kando/config.json" = lib.mkIf (cfg.settings != {}) {
          text = builtins.toJSON cfg.settings;
        };
        "kando/menus.json" = let
          merged = {
            menus = cfg.menus;
            templates = [];
          };
        in
          lib.mkIf (cfg.menus != []) {
            text = builtins.toJSON merged;
          };
      }
      // (lib.mapAttrs' (n: v: lib.nameValuePair "kando/icon-themes/${n}" {source = v;}) cfg.customIconThemePaths)
    );
  };
}
