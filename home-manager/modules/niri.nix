{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.niri;
in {
  options = {
    programs.niri = {
      enable = lib.mkEnableOption "enable niri wayland compositor configuration";
      settings = lib.mkOption {
        type = with lib.types; listOf str;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile."niri/config.kdl".text = builtins.concatStringsSep "\n" cfg.settings;
    systemd.user = {
      enable = true;
      services.xwayland-satellite = {
        Service = {
          ExecStart = lib.getExe pkgs.xwayland-satellite;
          Restart = "on-failure";
          RestartSec = 30;
        };
        Install = {
          WantedBy = ["default.target"];
        };
      };
    };
    home.sessionVariables = {
      DISPLAY = ":0";
    };
  };
}
