{
  lib,
  config,
  ...
}: let
  cap = config.capabilities;
in
  with lib; {
    options.capabilities.bluetooth.enable = mkEnableOption "enable bluetooth configuration";

    config = mkIf cap.bluetooth.enable {
      hardware.bluetooth.enable = true;
      hardware.bluetooth.powerOnBoot = true;
      services.blueman.enable = true;

      environment.persistence.${cap.optInPersistence.paths.system} = mkIf cap.optInPersistence.enable {
        directories = ["/var/lib/bluetooth"];
      };
    };
  }
