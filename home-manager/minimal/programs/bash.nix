{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.programs.bash.enable {
    programs = {
      fd.enable = true;
      jq.enable = true;
      fzf = {
        enable = true;
        enableBashIntegration = true;
      };
      starship = {
        enable = true;
        enableBashIntegration = true;
      };
      # eza = {
      #   enable = true;
      #   enableBashIntegration = true;
      # };
      bash.shellAliases = {
        "l" = "ls";
        "ll" = "ls -l";
        "lg" = "ls -lg";
        "la" = "ls -la";
        "lt" = "ls -la --total-size";
        "o" = "xdg-open";
        "+" = "nix-shell -p";
        ".." = "z ..";
        "..." = "z ..;z ..";
        "...." = "z ..;z ..;z ..";
      };
    };

    custom.ephemeral.local = {
      files = [".bash_history"];
    };
  };
}
