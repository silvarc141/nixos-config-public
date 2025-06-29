{lib, ...}: {
  imports = lib.custom.getImportable ./.;

  options.custom.graphical = {
    enable = lib.mkEnableOption "graphical environment configuration";
  };
}
