{
  config,
  lib,
  ...
}: {
  custom.ephemeral.large = {
    directories = [
      # Has to be a symlink, breaks bindfs (https://github.com/waydroid/waydroid/issues/828).
      # Issue with symlinks: waydroid init most likely expects '.local/share/waydroid' to exist, while '.local/share/waydroid/data' to not be a symlink
      # Temporary solution, turn this off, do waydroid init, then turn back.
      ".local/share/waydroid"
    ];
  };

  # xdg.desktopEntries = {
  #   tft = {
  #     name = "Teamfight Tactics";
  #     exec = "waydroid app launch com.riotgames.league.teamfighttactics";
  #     icon = "/home/${config.home.username}/.local/share/waydroid/data/icons/com.riotgames.league.teamfighttactics.png";
  #   };
  # };
}
