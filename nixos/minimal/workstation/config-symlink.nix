{
  lib,
  config,
  ...
}: {
  options.custom.workstation.configSymlink.enable = lib.mkEnableOption "enable nixos configuration symlink to main user home directory";

  config = lib.mkIf config.custom.workstation.configSymlink.enable {
    environment.etc.nixos = {
      enable = true;
      source = "/home/${config.custom.mainUser.name}/nixos";
    };
  };
}
