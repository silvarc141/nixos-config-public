{
  config,
  lib,
  inputs,
  ...
}: {
  imports = [inputs.disko.nixosModules.default];

  options.custom.disko = {
    enable = lib.mkEnableOption "partitions configuration through disko";
    deviceName = lib.mkOption {
      type = lib.types.str;
      default = "/dev/nvme0n1";
      description = "Device path for the main disk";
    };
    swapSize = lib.mkOption {
      type = lib.types.str;
      default = "32G";
      description = "Size of the swap file";
    };
    keyFile = lib.mkOption {
      type = lib.types.str;
      default = "/key/${config.networking.hostName}.key";
      description = "Path to the LUKS key file";
    };
    keyDisk = lib.mkOption {
      type = lib.types.str;
      default = "/dev/disk/by-label/KEY";
      description = "Device path for the disk containing the encryption key";
    };
    storage = lib.mkOption {
      type = with lib.types; listOf attrs;
      default = [];
      description = "List of storage disk configurations that are updated on top of defaults";
    };
  };

  config.disko.devices = let
    inherit (lib) mkIf;
    cfg = config.custom;
    unattended = cfg.boot.fullDiskEncryption.unattendedDecryption.enable;
    main = {
      device = cfg.disko.deviceName;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          esp = {
            name = "ESP";
            start = "1M";
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = ["umask=0077"];
            };
          };
          luks = {
            size = "100%";
            content = {
              type = "luks";
              name = "cryptroot";
              settings =
                {
                  allowDiscards = true;
                  bypassWorkqueues = true;
                }
                // mkIf unattended {
                  keyFileTimeout = 1;
                  keyFile = cfg.disko.keyFile;
                };
              content = {
                type = "lvm_pv";
                vg = "root_vg";
              };
            };
          };
        };
      };
    };
    root_vg = {
      type = "lvm_vg";
      lvs = {
        root = {
          size = "100%FREE";
          content = {
            type = "btrfs";
            extraArgs = ["-L" "nixos" "-f"];
            subvolumes = {
              "/root" = {
                mountpoint = "/";
                mountOptions = ["subvol=root" "noatime"];
              };
              "/persist" = {
                mountOptions = ["subvol=persist" "noatime"];
                mountpoint = "/persist";
              };
              "/nix" = {
                mountOptions = ["subvol=nix" "noatime"];
                mountpoint = "/nix";
              };
              "/swap" = {
                mountpoint = "/swap";
                swap.swapfile.size = cfg.disko.swapSize;
              };
            };
          };
        };
      };
    };
    storageDefaults = {
      type = "disk";
      device = "/dev/sdb";
      content = {
        type = "gpt";
        partitions = {
          storage = {
            size = "100%";
            content = {
              type = "luks";
              name = "cryptstorage";
              settings = mkIf unattended {
                keyFile = cfg.disko.keyFile;
              };
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/storage";
              };
            };
          };
        };
      };
    };
    storageList = builtins.listToAttrs (
      lib.imap0 (index: storage: {
        name = "storage${toString (index + 1)}";
        value = lib.recursiveUpdate storageDefaults storage;
      })
      cfg.disko.storage
    );
  in
    lib.mkIf config.custom.disko.enable {
      disk = {inherit main;} // storageList;
      lvm_vg = {inherit root_vg;};
    };
}
