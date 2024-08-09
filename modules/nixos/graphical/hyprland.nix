{
  lib,
  config,
  ...
}:
with lib; {
  options.capabilities.graphical.hyprland.enable = mkEnableOption "enable hyprland configuration";

  config = mkIf config.capabilities.graphical.hyprland.enable {
    programs.hyprland.enable = true;

    # allow hyprlock to unlock session
    security.pam.services.hyprlock = {};

    services.logind = {
      extraConfig = ''
        IdleAction=lock
      '';
    };

    environment.variables = {
      TERM = "alacritty";

      # hint electron apps to use wayland
      NIXOS_OZONE_WL = "1";
    };
  };
}
