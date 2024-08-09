{
  inputs,
  outputs,
  config,
  lib,
  ...
}: let
  cap = config.capabilities;
  cfg = cap.singleUser;
in
  with lib; {
    options.capabilities.singleUser = {
      enable = mkEnableOption "enable single user configuration";
      name = mkOption {
        default = "user";
        type = with types; uniq str;
      };
    };

    config = mkIf cfg.enable {
      home-manager = {
        users.${cfg.name} = import (./. + "/../../home-manager/${cfg.name}.nix");
        extraSpecialArgs = {inherit inputs outputs;};
      };

      users.users.${cfg.name} = {
        isNormalUser = true;
        extraGroups =
          ["wheel"]
          ++ lib.optionals (config.networking.networkmanager.enable) ["networkmanager"]
          ++ lib.optionals (cap.graphical.gaming.enable) ["gamemode"];
        #++ lib.optionals (sops.enable) ["keys"];
        hashedPasswordFile = config.sops.secrets.password.path;
      };

      sops.secrets.password.neededForUsers = true;
    };
  }
