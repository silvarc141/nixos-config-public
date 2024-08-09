{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.capabilities.fingerprint.enable = mkEnableOption "enable fingerprint configuration";

  config = mkIf config.capabilities.fingerprint.enable {
    services.fprintd = {
      # build issue
      enable = false;
      tod.enable = true;
      tod.driver = pkgs.libfprint-2-tod1-vfs0090;
    };
  };
}
