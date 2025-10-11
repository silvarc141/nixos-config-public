{
  lib,
  config,
  pkgs,
  ...
}: {
  options.programs.gimp.enable = lib.mkEnableOption "GIMP, the GNU image manipulation software";

  config = lib.mkIf config.programs.gimp.enable {
    home.packages = with pkgs; [gimp3];
    custom.ephemeral = {
      data.directories = [
        ".config/GIMP/3.0"
      ];
    };
  };
}
