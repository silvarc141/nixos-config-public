{
  lib,
  config,
  pkgs,
  ...
}: {
  options.programs.helvum.enable = lib.mkEnableOption "enable Helvum pipewire graph tool";

  config = lib.mkIf config.programs.helvum.enable {
    home.packages = with pkgs; [helvum];
  };
}
