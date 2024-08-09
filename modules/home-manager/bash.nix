{
  lib,
  nixosConfig,
  ...
}: let
  cap = nixosConfig.capabilities;
in
  with lib; {
    home.shellAliases = {
      "l" = "ls";
      "ll" = "ls -l";
      "lg" = "ls -lg";
      "la" = "ls -la";
      "lt" = "ls -la --total-size";
      "+" = "nix-shell -p";
      ".." = "z ..";
      "..." = "z ..;z ..";
      "...." = "z ..;z ..;z ..";
    };

    programs = {
      bash.enable = true;
      bat.enable = true;
      ripgrep.enable = true;
      fd.enable = true;
      btop.enable = true;
      jq.enable = true;

      fzf = {
        enable = true;
        enableBashIntegration = true;
      };

      starship = {
        enable = true;
        enableBashIntegration = true;
      };

      eza = {
        enable = true;
        enableBashIntegration = true;
      };

      zoxide = {
        enable = true;
        enableBashIntegration = true;
      };
    };

    home.persistence."${cap.optInPersistence.paths.home}/${cap.singleUser.name}" = mkIf cap.optInPersistence.enable {
      directories = [
        ".local/share/zoxide"
      ];
    };
  }
