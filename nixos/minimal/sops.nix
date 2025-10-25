{
  pkgs,
  inputs,
  config,
  paths,
  ...
}: {
  imports = [inputs.sops-nix.nixosModules.sops];
  sops = {
    defaultSopsFile = paths.secrets + "/system.yaml";
    defaultSopsFormat = "yaml";
    age.keyFile = "${config.custom.ephemeral.settings.absoluteSystemPath}/key.txt";

    # temp fix for https://github.com/Mic92/sops-nix/issues/167
    age.sshKeyPaths = [];
    gnupg.sshKeyPaths = [];
  };
  environment.systemPackages = [pkgs.sops pkgs.age];
}
