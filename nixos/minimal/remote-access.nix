{
  config,
  lib,
  ...
}: {
  options.custom.remoteAccess.enable = lib.mkEnableOption "remote access configuration";

  config = lib.mkIf config.custom.remoteAccess.enable {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = lib.mkDefault false;
        PermitRootLogin = "no";
        AllowUsers = [config.custom.mainUser.name];
      };
      hostKeys = [
        {
          path = "/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
    };
    security.pam = {
      sshAgentAuth.enable = true;
      services.sudo.sshAgentAuth = true;
    };
    users.users.${config.custom.mainUser.name}.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKhJcjsxhsgxS8d5rl+SbqF/S4t3RZuA09GZA+T6xHQl @id_ed25519"
    ];
    custom.ephemeral = {
      install.files = [
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
      ];
    };
  };
}
