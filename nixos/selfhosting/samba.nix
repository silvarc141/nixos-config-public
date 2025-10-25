# for now imperatively create paswords using smbpasswd
{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.custom;
  sharing = cfg.printing.sharing.enable;
in
  mkIf config.services.samba.enable {
    users.groups.media = {};

    custom.ephemeral.data.directories = [
      "/var/lib/samba"
      "/var/spool/samba"
    ];

    users.users = {
      julia = {
        isNormalUser = true;
        extraGroups = ["users"];
        home = "/storage/homes/julia";
      };
      marta = {
        isNormalUser = true;
        extraGroups = ["users" "media"];
        home = "/storage/homes/marta";
      };
    };

    services = {
      samba = {
        openFirewall = true;
        settings = {
          global = {
            "security" = "user";
            "workgroup" = "WORKGROUP";
            "server string" = "Home Server";
            "netbios name" = "home-server";
            "hosts allow" = "192.168.8. 127.0.0.1 localhost";
            "hosts deny" = "0.0.0.0/0";
            "map to guest" = "bad user";

            # printer sharing
            "load printers" = mkIf sharing "yes";
            "printing" = mkIf sharing "cups";
            "printcap name" = mkIf sharing "cups";
          };
          printers = mkIf sharing {
            "comment" = "All Printers";
            "path" = "/var/spool/samba";
            "public" = "yes";
            "browseable" = "yes";
            # to allow user 'guest account' to print.
            "guest ok" = "yes";
            "writable" = "no";
            "printable" = "yes";
            "create mode" = 0700;
          };
          homes = {
            "comment" = "Home Directories";
            "browseable" = "no";
            "read only" = "no";
            "valid users" = "%S";
            "create mask" = "0600";
            "directory mask" = "0700";
          };
          public = {
            "path" = "/storage/shares/public";
            "comment" = "Public shared folder for all users";
            "browseable" = "yes";
            "read only" = "no";
            "guest ok" = "no";
            "valid users" = "@users";
            "create mask" = "0664";
            "directory mask" = "0775";
          };
          media = {
            "path" = "/storage/media";
            "comment" = "Jellyfin Media Library";
            "browseable" = "yes";
            "read only" = "no";
            "guest ok" = "no";
            "valid users" = "@media";
            "create mask" = "0664";
            "directory mask" = "0775";
            "force group" = "media";
          };
        };
      };
      samba-wsdd = {
        enable = true;
        openFirewall = true;
      };
    };
    systemd.tmpfiles.rules = [
      "d /var/spool/samba 1777 root root -"
    ];
  }
