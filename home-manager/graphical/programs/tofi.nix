{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom;
in {
  config = lib.mkIf config.programs.tofi.enable {
    programs.tofi = {
      settings = {
        hide-cursor = true;
        history = true;
        fuzzy-match = true;
        drun-launch = true;

        #width = "100%";
        #height = "33";
        #anchor = "bottom";
        #horizontal = false;
        min-input-width = 120;
        font-size = 15;
        prompt-text = ''" > "'';
        font = "Iosevka";
        border-width = 0;
        outline-width = 0;
        padding-left = 0;
        padding-top = 0;
        padding-bottom = 0;
        padding-right = 0;
        result-spacing = 15;
        background-color = "#000000";
      };
    };
    custom.ephemeral.local = {
      directories = [
        ".local/state/tofi-history"
        ".local/state/tofi-drun-history"
      ];
    };
    custom.graphical.desktopAgnostic = {
      dmenuCommand = lib.getExe pkgs.tofi;
      extraCommands.launcher = "${pkgs.tofi}/bin/tofi-drun";
    };
  };
}
