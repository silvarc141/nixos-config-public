{
  config,
  pkgs,
  lib,
  ...
}: {
  options.programs.slack.enable = lib.mkEnableOption "enable slack communication software";

  config = lib.mkIf config.programs.slack.enable {
    home.packages = with pkgs; [slack];

    custom.ephemeral.data = {
      directories = [
        ".config/Slack"
      ];
    };
  };
}
