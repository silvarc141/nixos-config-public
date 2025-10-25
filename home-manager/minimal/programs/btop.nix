{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.programs.btop.enable {
    programs.btop.settings = {
      vim_keys = true;
    };
  };
}
