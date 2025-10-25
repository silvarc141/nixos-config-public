{
  lib,
  config,
  ...
}: {
  options.programs.cargo.enable = lib.mkEnableOption "cargo, rust's tool global configuration";

  config = lib.mkIf config.programs.cargo.enable {
    custom.ephemeral.local = {
      files = [".cargo"];
    };
  };
}
