{
  lib,
  config,
  pkgs,
  ...
}: {
  options.programs.mission-center.enable = lib.mkEnableOption "Mission Center, system resources monitor";

  config = lib.mkIf config.programs.mission-center.enable {
    home.packages = [pkgs.mission-center];
  };
}
