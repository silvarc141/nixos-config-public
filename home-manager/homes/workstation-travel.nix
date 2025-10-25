# essentials only, prioritizes low power consumption
{...}: {
  config = {
    custom = {
      graphical.enable = true;
      secrets.enable = true;
      ephemeral.enable = true;
      presets = {
        minimal = {
          shell.enable = true;
          dev.enable = true;
        };
        graphical = {
          basics.enable = true;
          desktop.enable = true;
        };
      };
    };
    wayland.windowManager.hyprland.settings.animations.enabled = "no";
  };
}
