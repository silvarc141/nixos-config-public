{
  lib,
  config,
  ...
}: {
  options.custom.modem.enable = lib.mkEnableOption "enable modem configuration";

  config = lib.mkIf config.custom.modem.enable {
    users.users.${config.custom.mainUser.name}.extraGroups = ["dialout"];
  };
}
