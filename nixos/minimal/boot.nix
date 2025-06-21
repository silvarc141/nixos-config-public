{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.custom;
  secureBootPath = "/etc/secureboot";
in {
  options.custom.boot = {
    enable = lib.mkEnableOption "enable boot configuration";
    secureBoot.enable = lib.mkEnableOption "enable secure boot configuration";
    fullDiskEncryption = {
      enable = lib.mkEnableOption "enable full disk encryption configuration";
      unattendedDecryption.enable = lib.mkEnableOption "enable configuration of unattended decryption during boot";
    };
    hibernation = {
      enable = lib.mkEnableOption "enable hibernation configuration";
      offset = lib.mkOption {
        description = ''
          Swap file offset for hibernation, needed if full disk encryption is used.
          Use the following command to get the offset for btrfs in /swap/swapfile:
          "sudo btrfs inspect-internal map-swapfile -r /swap/swapfile"
        '';
        type = lib.types.int;
        default = 0;
      };
    };
  };

  imports = [inputs.lanzaboote.nixosModules.lanzaboote];

  config = lib.mkIf cfg.boot.enable {
    boot = {
      # for cross compilation of mobile-nixos
      binfmt.emulatedSystems = ["aarch64-linux"];
      loader = {
        efi.canTouchEfiVariables = true;
        timeout = 0;
        systemd-boot = {
          enable = lib.mkForce (cfg.boot.secureBoot.enable == false);
          configurationLimit = 15;
        };
      };
      lanzaboote = lib.mkIf cfg.boot.secureBoot.enable {
        enable = true;
        pkiBundle = (
          if cfg.ephemeral.enable
          then cfg.ephemeral.settings.absoluteSystemPath + "/data" + secureBootPath
          else secureBootPath
        );
      };
      kernelParams = lib.optionals (cfg.boot.hibernation.enable && cfg.boot.fullDiskEncryption.enable) [
        "resume_offset=${builtins.toString cfg.boot.hibernation.offset}"
      ];
      resumeDevice = lib.mkDefault "/dev/disk/by-label/nixos";
      initrd = {
        systemd = {
          enable = true;
          services = {
            # cryptsetup has to wait after the mounting script *ENDS*, change if there is a better way
            "systemd-cryptsetup@" = {
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
        kernelModules = lib.mkIf cfg.boot.fullDiskEncryption.unattendedDecryption.enable ["uas" "usb_storage" "vfat" "nls_cp437" "nls_iso8859_1"];
      };
    };
    environment.systemPackages = lib.mkIf cfg.boot.secureBoot.enable [pkgs.sbctl];
    custom.ephemeral.data.directories = [secureBootPath];
  };
}
