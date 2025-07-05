{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.programs.direnv.enable {
    programs.direnv = {
      enableNushellIntegration = lib.mkIf config.programs.nushell.enable true;
    };
  };
}
