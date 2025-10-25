{
  lib,
  config,
  pkgs,
  ...
}: {
  options.programs.inkscape.enable = lib.mkEnableOption "Inkscape vector graphics manipulation software";

  config = lib.mkIf config.programs.inkscape.enable {
    home.packages = with pkgs; [inkscape];
    custom.ephemeral = {
      data.directories = [
        ".config/inkscape"
      ];
    };
  };
}
