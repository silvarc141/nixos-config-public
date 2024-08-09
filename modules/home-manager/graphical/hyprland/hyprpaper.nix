{
  enable,
  lib,
  ...
}: {
  config.services.hyprpaper = lib.mkIf enable {
    enable = true;
    settings = {
      wallpapers = ["eDP-1,${../../../../wallpapers/bliss-night.webp}"];
      preloads = ["${../../../../wallpapers/bliss-night.webp}"];
    };
  };
}
