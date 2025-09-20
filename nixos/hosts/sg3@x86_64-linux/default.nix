{
  lib,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault;
in {
  imports = [inputs.nixos-hardware.nixosModules.microsoft-surface-go];
  config = {
    custom = {
      disko = {
        enable = true;
        deviceName = "/dev/nvme0n1";
        swapSize = "3G";
      };
      boot = {
        enable = true;
        fullDiskEncryption = {
          enable = true;
          unattendedDecryption.enable = true;
        };
        secureBoot.enable = true;
      };
      tty.enable = true;
      # disable bluetooth to save battery
      # bluetooth.enable = true;
      audio.enable = true;
      usb.enable = true;
      lid.enable = true;
      ephemeral.enable = true;
      mainUser = {
        hasSecretsAccess = true;
        homeType = "workstation-travel";
      };
      graphical = {
        enable = true;
        windowManager = "hyprland";
        gaming.enable = true;
      };
      workstation = {
        sambaMount.enable = true;
        configSymlink.enable = true;
      };
    };
    networking.useDHCP = mkDefault true;
    nixpkgs.hostPlatform = "x86_64-linux";

    powerManagement.powertop.enable = true;
    environment.systemPackages = with pkgs; [powertop];

    services.thermald = {
      enable = true;
      configFile =
        pkgs.writeText "thermald-config"
        #xml
        ''
          <?xml version="1.0" encoding="UTF-8"?>
          <ThermalConfiguration>
            <Platform>
              <Name>Intel Powered Laptop</Name>
              <ProductName>*</ProductName>
              <Preference>QUIET</Preference>
              <ThermalZones>
                <ThermalZone>
                  <Type>cpu</Type>
                  <TripPoints>
                    <TripPoint>
                      <SensorType>x86_pkg_temp</SensorType>
                      <Temperature>65000</Temperature>
                      <type>passive</type>
                      <ControlType>SEQUENTIAL</ControlType>
                      <CoolingDevice>
                        <index>1</index>
                        <type>rapl_controller</type>
                        <influence>100</influence>
                        <SamplingPeriod>5</SamplingPeriod>
                      </CoolingDevice>
                    </TripPoint>
                  </TripPoints>
                </ThermalZone>
              </ThermalZones>
            </Platform>
          </ThermalConfiguration>
        '';
    };

    services.pcscd.enable = true;

    # touch disk decryption and general usability (input interruption issue)
    boot.initrd = {
      unl0kr.enable = true;
      availableKernelModules = [
        "evdev"
        "i915"
        "pinctrl_sunrisepoint"
        "intel_lpss_pci"
        "intel_lpss"
      ];
    };

    # disable touchscreen kernel module to save battery
    # boot.blacklistedKernelModules = [ "i2c_hid_acpi" ];

    # disable modem to save battery
    # environment.systemPackages = with pkgs; [
    #   modem-manager-gui
    #   lpa-gtk
    #   cheese
    # ];
    # programs.calls.enable = true;
    # networking.modemmanager.enable = true;
    # systemd.services.ModemManager = {
    #   enable = lib.mkForce true;
    #   wantedBy = ["multi-user.target" "network.target"];
    #   serviceConfig.ExecStartPre = lib.getExe (
    #     pkgs.writeShellScriptBin "modem-manager-pre-start-fix" ''
    #       set -e
    #
    #       SYS_PATH="/sys/bus/usb/devices/2-3:1.0/net/wwp0s20f0u3/cdc_ncm"
    #       TIMEOUT=30
    #       ELAPSED=0
    #
    #       echo "Waiting for modem path $SYS_PATH to appear..."
    #
    #       while [ ! -d "$SYS_PATH" ]; do
    #         if [ $ELAPSED -ge $TIMEOUT ]; then
    #           echo "Error: Timed out after $TIMEOUT seconds waiting for modem path." >&2
    #           exit 1
    #         fi
    #         sleep 1
    #         ELAPSED=$((ELAPSED + 1))
    #       done
    #
    #       echo "Modem path found. Applying buffer fix."
    #       echo -n 16383 > "$SYS_PATH/rx_max"
    #       echo -n 16383 > "$SYS_PATH/tx_max"
    #       echo -n 16384 > "$SYS_PATH/rx_max"
    #       echo -n 16384 > "$SYS_PATH/tx_max"
    #       echo "Modem fix applied successfully."
    #     ''
    #   );
    # };
  };
}
