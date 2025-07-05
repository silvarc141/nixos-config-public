{
  lib,
  config,
  paths,
  ...
}: {
  config.services.hyprpaper = lib.mkIf config.services.hyprpaper.enable {
    settings = let
      wallpaperPath = "${paths.assets}/bliss-night.webp";
    in {
      splash = false;
      preload = [wallpaperPath];
      wallpaper = ["eDP-1,${wallpaperPath}"];
    };
  };
}
