{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.services.udiskie.enable {
    services.udiskie.settings = {
      program_options = {
        menu = "flat";
      };
      device_config = [
        {
          # ignore unattended decryption key drive
          id_label = "KEY";
          ignore = true;
          # not sure why it's still automounting, bugged?
        }
        {
          # ignore waydroid mounts
          is_loop = true;
          ignore = true;
        }
      ];
      notifications = {
        device_mounted = -1;
        device_unmounted = false;
        device_added = false;
        device_removed = -1;
      };
    };
  };
}
