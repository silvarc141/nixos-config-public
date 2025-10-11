{config, ...}: {
  security.sudo.extraConfig = ''
    Defaults lecture="never"
    Defaults timestamp_timeout=1
  '';

  users.users.${config.custom.mainUser.name}.extraGroups = ["wheel"];
}
