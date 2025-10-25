{...}: {
  custom = {
    # graphical.enable = true;
    secrets.enable = true;
    presets = {
      minimal = {
        shell.enable = true;
        dev.enable = true;
      };
      # graphical = {
      #   basics.enable = true;
      #   desktop.enable = true;
      #   debug.enable = true;
      # };
    };
  };
}
