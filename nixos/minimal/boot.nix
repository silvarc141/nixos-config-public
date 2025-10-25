{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  inherit (lib) mkIf mkForce mkEnableOption mkOption types mkDefault optionals;
  cfg = config.custom;
  secureBootPath = "/var/lib/sbctl";
in {
  imports = [inputs.lanzaboote.nixosModules.lanzaboote];

  options.custom.boot = {
    enable = mkEnableOption "enable boot configuration";
    secureBoot.enable = mkEnableOption "enable secure boot configuration";
    fullDiskEncryption = {
      enable = mkEnableOption "enable full disk encryption configuration";
      unattendedDecryption.enable = mkEnableOption "enable configuration of unattended decryption during boot";
    };
    hibernation = {
      enable = mkEnableOption "enable hibernation configuration";
      offset = mkOption {
        description = ''
          Swap file offset for hibernation, needed if full disk encryption is used.
          Use the following command to get the offset for btrfs in /swap/swapfile:
          "sudo btrfs inspect-internal map-swapfile -r /swap/swapfile"
        '';
        type = types.int;
        default = 0;
      };
    };
  };

  config = mkIf cfg.boot.enable {
    boot = {
      loader = {
        efi.canTouchEfiVariables = true;
        timeout = 0;
        systemd-boot = {
          enable = mkForce (cfg.boot.secureBoot.enable == false);
          configurationLimit = 15;
        };
      };
      lanzaboote = mkIf cfg.boot.secureBoot.enable {
        enable = true;
        pkiBundle = (
          if cfg.ephemeral.enable
          then cfg.ephemeral.settings.absoluteSystemPath + "/data" + secureBootPath
          else secureBootPath
        );
      };
      kernelParams = optionals (cfg.boot.hibernation.enable && cfg.boot.fullDiskEncryption.enable) [
        "resume_offset=${builtins.toString cfg.boot.hibernation.offset}"
      ];
      resumeDevice = mkDefault "/dev/disk/by-label/nixos";
      initrd = {
        systemd = {
          enable = true;
          services = {
            # cryptsetup has to wait after the mounting script *ENDS*, change if there is a better way
            "systemd-cryptsetup@" = mkIf cfg.boot.fullDiskEncryption.unattendedDecryption.enable {
              overrideStrategy = "asDropin";
              preStart = let
                dir = dirOf cfg.disko.keyFile;
              in ''
                mkdir -m 0700 -p ${dir}
                sleep 2 # make sure usb is loaded
                mount -n -r -t vfat -o umask=077 ${cfg.disko.keyDisk} ${dir} || true
              '';
            };
          };
        };
        # modules for vfat mount from initrd
        kernelModules = mkIf cfg.boot.fullDiskEncryption.unattendedDecryption.enable ["uas" "usb_storage" "vfat" "nls_cp437" "nls_iso8859_1"];
      };
    };
    environment.systemPackages = mkIf cfg.boot.secureBoot.enable [pkgs.sbctl];
    custom.ephemeral.data.directories = [secureBootPath];
  };
}
