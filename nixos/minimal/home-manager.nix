{
  config,
  inputs,
  lib,
  paths,
  customUtils,
  hostName,
  ...
}: let
  cfg = config.custom;
  homeKeyBasename = "home-key-${cfg.mainUser.name}";

  hostSpecificPath = "${paths.homeManagerConfig}/host-specific";
  hostSpecificFiles = lib.attrNames (customUtils.readDirImportable hostSpecificPath);
  hostSpecificNamesWithConfig = map (path: lib.strings.removeSuffix ".nix" path) hostSpecificFiles;
  hostSpecificCondition = builtins.elem hostName hostSpecificNamesWithConfig;
in {
  imports = [inputs.home-manager.nixosModules.home-manager];

  config = lib.mkIf (cfg.mainUser.homeType != "none") {
    home-manager = {
      useGlobalPkgs = true;
      users.${cfg.mainUser.name} = {
        imports =
          [
            (import paths.homeManagerConfig)
          ]
          ++ (lib.optionals hostSpecificCondition [(import "${paths.homeManagerConfig}/host-specific/${hostName}.nix")]);
      };
      extraSpecialArgs = {
        inherit inputs paths customUtils;
        inherit (config.networking) hostName;
        homeType = cfg.mainUser.homeType;
        isNixosModule = true;
      };
      backupFileExtension = "hbak";
    };

    sops.secrets.${homeKeyBasename} = lib.mkIf cfg.mainUser.hasSecretsAccess {
      sopsFile = "${paths.secrets}/workstation.yaml";
      mode = "0400";
      owner = cfg.mainUser.name;
    };

    environment.etc.${homeKeyBasename} = lib.mkIf cfg.mainUser.hasSecretsAccess {
      source = config.sops.secrets.${homeKeyBasename}.path;
    };
  };
}
