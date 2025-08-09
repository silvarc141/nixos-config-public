{
  config,
  inputs,
  lib,
  paths,
  customUtils,
  ...
}: let
  cfg = config.custom;
in {
  imports = [inputs.home-manager.nixosModules.home-manager];

  home-manager = {
    useGlobalPkgs = true;
    users.${cfg.mainUser.name} = import paths.homeManagerConfig;
    extraSpecialArgs = {
      inherit inputs paths customUtils;
      inherit (config.networking) hostName;
      homeType = cfg.mainUser.homeType;
      isNixosModule = true;
    };
    backupFileExtension = "hbak";
  };

  sops.secrets.home-key = lib.mkIf cfg.mainUser.hasSecretsAccess {
    sopsFile = "${paths.secrets}/workstation.yaml";
    mode = "0400";
    owner = cfg.mainUser.name;
  };

  environment.etc.home-key = lib.mkIf cfg.mainUser.hasSecretsAccess {
    source = config.sops.secrets.home-key.path;
  };
}
