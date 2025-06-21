{
  pkgs,
  lib,
  config,
  ...
}: {
  options.programs.aider.enable = lib.mkEnableOption "aider, AI code assistant for terminal";

  config = let
    format = pkgs.formats.yaml {};
    settings = {};
  in
    lib.mkIf config.programs.aider.enable {
      home.packages = with pkgs; [aider-chat];
      # xdg.configFile."kando/config.json" = lib.mkIf (settings != {}) {
      #   source = format.generate "aider-config" settings;
      # };
      programs.git = lib.mkIf config.programs.git.enable {
        ignores = [
          # add aider paths
        ];
      };
    };
}
