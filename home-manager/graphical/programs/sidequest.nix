{
  lib,
  config,
  pkgs,
  ...
}: {
  options.programs.sidequest.enable = lib.mkEnableOption "SideQuest VR sideloading app";

  config = lib.mkIf config.programs.sidequest.enable {
    home.packages = [pkgs.sidequest];
    custom.ephemeral.data.directories = [".config/SideQuest"];
  };
}
