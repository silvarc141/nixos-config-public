{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.custom;
in {
  options.programs.obsidian.enable = lib.mkEnableOption "Obsidian markdown note taking utility";

  config = lib.mkIf config.programs.obsidian.enable {
    home.packages = with pkgs; [
      obsidian
      glow
    ];

    custom.ephemeral.data = {
      directories = [".config/obsidian"];
    };
  };
}
