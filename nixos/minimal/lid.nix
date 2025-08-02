{
  lib,
  config,
  ...
}: {
  options.custom.lid.enable = lib.mkEnableOption "enable lid configuration";

  config = lib.mkIf config.custom.lid.enable {
    services.logind = {
      lidSwitch = "hibernate";
      lidSwitchExternalPower = "hibernate";
      lidSwitchDocked = "ignore";
      powerKey = "poweroff";
    };
  };
}
