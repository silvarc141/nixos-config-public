{
  lib,
  customUtils,
  ...
}: {
  imports = customUtils.getImportable ./.;

  options.custom.graphical = {
    enable = lib.mkEnableOption "graphical environment configuration";
  };
}
