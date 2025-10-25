{
  lib,
  config,
  ...
}:
with lib; {
  options.custom.tty.enable = mkEnableOption "enable tty configuration";

  config = mkIf config.custom.tty.enable {
    environment.etc.issue.enable = false;
    # console = {
    #   enable = true;
    #   earlySetup = true;
    # };
    # services.kmscon = {
    #   enable = true;
    #   extraConfig = ''
    #     font-size=14
    #     xkb-layout=pl
    #     xkb-options=ctrl:nocaps
    #   '';
    # };
  };
}
