{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.custom.nixvim.enable {
    programs.nixvim = {
      plugins.direnv.enable = lib.mkIf config.programs.direnv.enable true;
    };
    custom.ephemeral.data.directories = [".local/share/direnv"];
  };
}
