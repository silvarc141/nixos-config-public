{
  config,
  inputs,
  lib,
  overlays,
  paths,
  customUtils,
  ...
}: let
  cfg = config.custom;
in {
  imports = [inputs.home-manager.nixosModules.home-manager];

  home-manager = {
    users.${cfg.mainUser.name} = import paths.homeManagerConfig;
    extraSpecialArgs = {
      inherit inputs overlays paths customUtils;
      homeType = cfg.mainUser.homeType;
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
