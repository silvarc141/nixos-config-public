{
  pkgs,
  lib,
  config,
  ...
}: {
  # this doesnt really work
  options.programs.pmbootstrap.enable = lib.mkEnableOption "pmbootstrap, postmarketOS utility";

  config = lib.mkIf config.programs.pmbootstrap.enable {
    home.packages = with pkgs; [
      pmbootstrap
    ];
    custom.ephemeral.local = {
      directories = [".local/var/pmbootstrap"];
      files = [".config/pmbootstrap_v3.cfg"];
    };
  };
}
