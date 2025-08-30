{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.custom;
in {
  options.programs.plasticscm.enable = lib.mkEnableOption "enable PlasticSCM source control";

  config = lib.mkIf config.programs.plasticscm.enable {
    home.packages = [pkgs.plastic-scm];

    custom.ephemeral.data = {
      directories = [
        ".plastic4"
      ];
    };
  };
}
