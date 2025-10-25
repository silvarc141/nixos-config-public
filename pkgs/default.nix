{
  pkgs,
  customUtils,
}:
builtins.mapAttrs (name: value:
    pkgs.callPackage ("${./.}/"
      + (
        if value != "directory"
        then builtins.substring 0 ((builtins.stringLength name) - 4) name
        else name
      ))
    {lib = pkgs.lib;}) (customUtils.readDirImportable ./.)
