{
  lib,
  config,
  ...
}:
with lib; {
  options.capabilities.trackpoint.enable = mkEnableOption "enable trackpoint configuration";

  config = mkIf config.capabilities.trackpoint.enable {
    # disable trackpoint
    services.udev.extraRules = ''
      # ALPS ThinkPad TrackPoint: Ignore as input device
      ATTRS{name}=="*TPPS/2 IBM TrackPoint", ENV{ID_INPUT}="", ENV{ID_INPUT_MOUSE}="", ENV{ID_INPUT_POINTINGSTICK}=""
    '';

    hardware.trackpoint = {
      enable = true;
      sensitivity = 100;
      speed = 60;
    };
  };
}
