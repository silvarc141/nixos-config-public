{
  lib,
  config,
  ...
}:
with lib; {
  options.capabilities.audio.enable = mkEnableOption "enable audio configuration";

  config = mkIf config.capabilities.audio.enable {
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      wireplumber.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };
}
