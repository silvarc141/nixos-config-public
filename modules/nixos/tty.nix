{
  lib,
  config,
  ...
}:
with lib; {
  options.capabilities.tty.enable = mkEnableOption "enable tty configuration";

  config = mkIf config.capabilities.tty.enable {
    services.kmscon = {
      enable = true;
      extraConfig = ''
        font-size=14
        xkb-layout=pl
        xkb-options=ctrl:nocaps
      '';
    };
  };
}
