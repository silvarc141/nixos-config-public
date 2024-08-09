args @ {
  enable,
  lib,
  pkgs,
  ...
}:
with lib; {
  imports = [
    (import ./hypridle.nix (args // {enable = enable;}))
    (import ./hyprland.nix (args // {enable = enable;}))
    (import ./hyprlock.nix (args // {enable = enable;}))
    (import ./hyprpaper.nix (args // {enable = enable;}))
    (import ./waybar.nix (args // {enable = enable;}))
    (import ./wlogout.nix (args // {enable = enable;}))
    (import ./wofi.nix (args // {enable = enable;}))
  ];

  config = mkIf enable {
    services.cliphist.enable = true;

    xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-hyprland];

    home.packages = with pkgs; [
      # required in path to properly copy images
      wl-clipboard
    ];
  };
}
