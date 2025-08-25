{
  lib,
  inputs,
  config,
  paths,
  ...
}: {
  imports = [inputs.sops-nix.homeManagerModules.sops];

  options.custom.secrets.enable = lib.mkEnableOption "enable secrets usage in configuration (leave disabled if no access)";

  config = lib.mkIf config.custom.secrets.enable {
    sops = {
      defaultSopsFile = "${paths.secrets}/home.yaml";
      age.keyFile = "/etc/home-key-${config.home.username}";
    };

    # persist personal key
    custom.ephemeral.data = {
      files = [".config/sops/age/keys.txt"];
    };
  };
}
