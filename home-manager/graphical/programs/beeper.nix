{
  lib,
  config,
  pkgs,
  ...
}: {
  options.programs.beeper.enable = lib.mkEnableOption "enable Beeper communication platform";

  config = lib.mkIf config.programs.beeper.enable {
    home.packages = with pkgs; [beeper];
    custom.ephemeral = {
      data.directories = [
        ".config/BeeperTexts"
      ];
    };
  };
}
