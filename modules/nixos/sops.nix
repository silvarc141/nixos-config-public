{
  inputs,
  pkgs,
  config,
  ...
}: let
  cap = config.capabilities;
  sshKeyPath = "/etc/ssh/ssh_host_ed25519_key";
in {
  imports = [inputs.sops-nix.nixosModules.sops];
  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.sshKeyPaths = [
    (
      if cap.optInPersistence.enable
      then cap.optInPersistence.paths.system + sshKeyPath
      else sshKeyPath
    )
  ];
  environment.systemPackages = [pkgs.sops pkgs.ssh-to-age pkgs.age];
}
