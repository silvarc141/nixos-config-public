{
  pkgs,
  config,
  lib,
  ...
}: {
  options.programs.waydroid.enable = lib.mkEnableOption "waydroid android compatibility layer";

  config = lib.mkIf config.programs.waydroid.enable {
    home.packages = with pkgs; [
      waydroid-helper
      unzip # needed for waydroid helper to unpack stuff
    ];
    custom.ephemeral.large = {
      directories = [
        # Has to be a symlink, breaks bindfs (https://github.com/waydroid/waydroid/issues/828).
        ".local/share/waydroid"
      ];
    };
    # Issue with symlinks: waydroid init most likely expects '.local/share/waydroid' to exist, while '.local/share/waydroid/data' to not be a symlink
    home.activation = lib.mkIf config.custom.ephemeral.enable {
      waydroidInitFix = lib.hm.dag.entryAfter ["writeBoundary"] ''
        mkdir -p /persist/home/${config.home.username}/large/.local/share/waydroid/data
      '';
    };
    # xdg.desktopEntries = {
    #   tft = {
    #     name = "Teamfight Tactics";
    #     exec = "waydroid app launch com.riotgames.league.teamfighttactics";
    #     icon = "/home/${config.home.username}/.local/share/waydroid/data/icons/com.riotgames.league.teamfighttactics.png";
    #   };
    # };
  };
}
