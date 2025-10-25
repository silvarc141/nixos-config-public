{
  config,
  pkgs,
  lib,
  ...
}: {
  options.programs.vital.enable = lib.mkEnableOption "enable Vital synth plugin";

  config = lib.mkIf config.programs.vital.enable {
    home.packages = with pkgs; [vital];

    custom.ephemeral.data = {
      directories = [
        ".local/share/vital"
        ".vital"
      ];
    };
  };
}
