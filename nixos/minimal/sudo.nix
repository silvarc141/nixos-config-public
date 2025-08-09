{config, ...}: {
  security.sudo.extraConfig = ''
    Defaults lecture="never"
    Defaults timestamp_timeout=0
  '';

  users.users.${config.custom.mainUser.name}.extraGroups = ["wheel"];
}
