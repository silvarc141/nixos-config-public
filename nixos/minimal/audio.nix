{
  lib,
  config,
  ...
}: {
  options.custom.audio.enable = lib.mkEnableOption "enable audio configuration";

  config = lib.mkIf config.custom.audio.enable {
    users.users.${config.custom.mainUser.name}.extraGroups = ["audio"];
    security.rtkit.enable = true;
    services.pulseaudio.enable = false;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber = {
        enable = true;
        extraConfig = {
          # hyperx-cloud-priority = {
          #   "monitor.alsa.rules" = [
          #     {
          #       matches = [
          #         {
          #           "node.name" = "~alsa_output.usb-HP__Inc_HyperX_Cloud_III_Wireless.*";
          #         }
          #       ];
          #       actions = {
          #         update-props = {
          #           "priority.session" = 2000;
          #           "node.priority" = 2000;
          #           "node.description" = "HyperX Cloud III Wireless Output";
          #         };
          #       };
          #     }
          #     {
          #       matches = [
          #         {
          #           "node.name" = "~alsa_input.usb-HP__Inc_HyperX_Cloud_III_Wireless.*";
          #         }
          #       ];
          #       actions = {
          #         update-props = {
          #           "priority.session" = 2000;
          #           "node.priority" = 2000;
          #           "node.description" = "HyperX Cloud III Wireless Input";
          #         };
          #       };
          #     }
          #   ];
          # };
          wh-1000xm4-ldac-hq = {
            "monitor.bluez.rules" = [
              {
                matches = [
                  {
                    "device.name" = "~bluez_card.*";
                    "device.product.id" = "0x0d58";
                    "device.vendor.id" = "usb:054c";
                  }
                ];
                actions = {
                  update-props = {
                    # Set quality to high quality instead of the default of auto
                    "bluez5.a2dp.ldac.quality" = "hq";
                  };
                };
              }
            ];
          };
        };
      };
    };
  };
}
