{
  lib,
  config,
  ...
}: {
  options.custom.lid.enable = lib.mkEnableOption "enable lid configuration";

  config = lib.mkIf config.custom.lid.enable {
    services.logind = {
      lidSwitch =
        if config.custom.boot.hibernation.enable
        then "hibernate"
        else "suspend";
      lidSwitchExternalPower =
        if config.custom.boot.hibernation.enable
        then "hibernate"
        else "suspend";
      lidSwitchDocked = "ignore";
      powerKey = "poweroff";
    };
  };
}
