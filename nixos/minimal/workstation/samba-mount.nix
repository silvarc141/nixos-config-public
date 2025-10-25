{
  lib,
  config,
  pkgs,
  paths,
  ...
}: let
  smbUsername = "marta";
in {
  options.custom.workstation.sambaMount.enable = lib.mkEnableOption "access samba share from a local server";

  config = lib.mkIf config.custom.workstation.sambaMount.enable {
    environment.systemPackages = [pkgs.cifs-utils];
    fileSystems = let
      mkShareMount = {smbPath}: {
        device = "//192.168.8.2/${smbPath}";
        fsType = "cifs";
        options = let
          # this line prevents hanging on network split
          automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
          # WARNING: hard-coded uid & gid
        in ["${automount_opts},credentials=${config.sops.templates."smb-credentials-${smbUsername}".path},uid=1000,gid=100"];
      };
    in {
      "/home/${config.custom.mainUser.name}/share/public" = mkShareMount {smbPath = "public";};
      "/home/${config.custom.mainUser.name}/share/private" = mkShareMount {smbPath = smbUsername;};
    };
    sops = {
      templates."smb-credentials-${smbUsername}" = {
        owner = config.custom.mainUser.name;
        mode = "0400";
        content = ''
          username=${smbUsername}
          password=${config.sops.placeholder."smb-password-${smbUsername}"}
        '';
      };
      secrets."smb-password-${smbUsername}" = {
        sopsFile = "${paths.secrets}/workstation.yaml";
      };
    };
  };
}
