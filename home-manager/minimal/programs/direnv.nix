{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.programs.direnv.enable {
    programs.direnv = {
      enableNushellIntegration = true;
    };
  };
}
