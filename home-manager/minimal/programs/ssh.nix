{
  config,
  lib,
  pkgs,
  ...
}: let
  known_hosts_github = pkgs.writeTextFile {
    name = "known_hosts_github";
    text = "github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
  };
in
  with lib; {
    config = mkIf config.programs.ssh.enable {
      programs.ssh = {
        userKnownHostsFile = "~/.ssh/known_hosts ${known_hosts_github}";
        forwardAgent = true;
      };
      services.ssh-agent.enable = true;
      custom.ephemeral.local = {
        directories = [".ssh"];
      };
    };
  }
