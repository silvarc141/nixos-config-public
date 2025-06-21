{
  lib,
  pkgs,
}:
builtins.mapAttrs (name: value:
    pkgs.callPackage ("${./.}/"
      + (
        if value != "directory"
        then builtins.substring 0 ((builtins.stringLength name) - 4) name
        else name
      ))
    # packages cannot depend on custom functions so we use lib from pkgs
    {lib = pkgs.lib;}) (lib.custom.readDirImportable ./.)
