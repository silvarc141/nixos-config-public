{
  config,
  lib,
  ...
}: let
  cfg = config.custom;
in {
  config = lib.mkIf config.programs.zoxide.enable {
    programs.zoxide = {
      enableBashIntegration = true;
      enableNushellIntegration = true;
    };

    custom.ephemeral.local = {
      directories = [".local/share/zoxide"];
    };
  };
}
