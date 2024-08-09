{
  lib,
  config,
  ...
}: {
  options.capabilities.lid.enable = lib.mkEnableOption "enable lid configuration";

  config = lib.mkIf config.capabilities.lid.enable {
    services.logind = {
      lidSwitch = "suspend";
      lidSwitchExternalPower = "ignore";
      lidSwitchDocked = "ignore";
    };
  };
}
