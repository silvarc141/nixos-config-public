{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.custom.graphical.enable {
    services.keyd = {
      enable = true;
      keyboards = {
        "mouse-meta-key" = {
          ids = [
            "046d:c099:6a628e3c" # Logitech G502 X
          ];
          settings = {
            main = {
              f23 = "leftmeta";
            };
          };
        };
      };
    };
  };
}
