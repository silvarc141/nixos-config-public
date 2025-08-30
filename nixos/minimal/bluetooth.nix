{
  lib,
  config,
  ...
}: {
  options.custom.bluetooth.enable = lib.mkEnableOption "enable bluetooth configuration";

  config = lib.mkIf config.custom.bluetooth.enable {
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    services.blueman.enable = true;

    custom.ephemeral = {
      data.directories = ["/var/lib/bluetooth"];
    };
  };
}
