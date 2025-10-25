{
  pkgs,
  lib,
  config,
  ...
}: {
  options.programs.android-tools.enable = lib.mkEnableOption "android tools";

  config = lib.mkIf config.programs.android-tools.enable {
    home.packages = with pkgs; [
      android-tools
      edl
    ];
    custom.ephemeral.local = {
      directories = [".android"];
    };
  };
}
