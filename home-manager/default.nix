{
  customUtils,
  paths,
  lib,
  homeType ? "minimal",
  hostName ? "",
  ...
}: let
  hostSpecificPath = "${paths.homeManagerConfig}/host-specific";
  hostSpecificFiles = lib.attrNames (customUtils.readDirImportable hostSpecificPath);
  hostNamesWithConfig = map (path: lib.strings.removeSuffix ".nix" path) hostSpecificFiles;
in {
  imports = (
    [
      ./modules
      ./minimal
      ./graphical
      (import "${paths.homeManagerConfig}/homes/${homeType}.nix")
    ]
    ++ lib.optionals (builtins.elem hostName hostNamesWithConfig) [
      (import "${paths.homeManagerConfig}/host-specific/${hostName}.nix")
    ]
  );
}
