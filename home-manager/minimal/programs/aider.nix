{
  pkgs,
  lib,
  config,
  ...
}: {
  options.programs.aider.enable = lib.mkEnableOption "aider, AI code assistant for terminal";

  config = let
    format = pkgs.formats.yaml {};
    settings = {
      dark-mode = true;
    };

    aiderWrapper = pkgs.writeShellScriptBin "aider-wrapper" ''
      ${lib.getExe pkgs.aider-chat} --model sonnet --api-key anthropic=$(cat ${config.sops.secrets.anthropic-api-key.path})
    '';
    wrapperPath = lib.getExe aiderWrapper;
    aliases = lib.genAttrs ["ai"] (name: wrapperPath);
  in
    lib.mkIf config.programs.aider.enable {
      home.packages = with pkgs; [aider-chat];

      programs.bash.shellAliases = aliases;
      programs.nushell.shellAliases = aliases;
      programs.git = lib.mkIf config.programs.git.enable {
        ignores = [
          ".aider*"
        ];
      };

      custom.ephemeral = {
        ignored = {
          files = [
            ".aider/analytics.json"
            ".aider/installs.json"
          ];
        };
        cache = {
          directories = [
            ".aider/caches"
          ];
        };
      };

      sops.secrets.anthropic-api-key = {};

      home.file.".aider.conf.yml" = lib.mkIf (settings != {}) {
        source = format.generate "aider-config" settings;
      };
    };
}
