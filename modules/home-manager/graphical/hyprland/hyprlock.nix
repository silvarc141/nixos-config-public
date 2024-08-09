{
  enable,
  lib,
  ...
}: {
  config.programs.hyprlock = lib.mkIf enable {
    enable = true;
    settings = {
      background = [
        {
          path = "screenshot";
          blur_passes = 2;
        }
      ];
      labels = [{text = "Type password to unlock";}];
    };
  };
}
