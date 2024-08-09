{
  inputs,
  lib,
  nixosConfig,
  ...
}: let
  cap = nixosConfig.capabilities;
in
  with lib; {
    imports = [inputs.impermanence.nixosModules.home-manager.impermanence];

    config = mkIf cap.optInPersistence.enable {
      home.persistence."${cap.optInPersistence.paths.home}/${cap.singleUser.name}" = {
        directories = [
          "nixos-config"
          "downloads"
          "notes"
          "projects"
          ".gnupg"
          ".ssh"
          ".nixops"
          ".local/share/keyrings"
          ".local/share/direnv"
          ".local/state/wireplumber"
          ".mozilla"
          ".config/1Password"
          ".config/discord"
          ".local/share/vulkan"
          {
            # A couple of games don't play well with bindfs
            directory = ".local/share/Steam";
            method = "symlink";
          }
        ];
        files = [
          ".config/sops/age/keys.txt"
          ".bash_history"
        ];
        allowOther = true;
      };

      commands.optInPersistenceDiff.enable = true;
    };
  }
