{
  lib,
  config,
  inputs,
  ...
}: {
  imports = [inputs.musnix.nixosModules.musnix];

  options.custom.workstation.audio.enable = lib.mkEnableOption "enable audio workstation configuration";

  config = lib.mkIf (config.custom.audio.enable && config.custom.workstation.audio.enable) {
    musnix.enable = true;
  };
}
