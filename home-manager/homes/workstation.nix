{...}: {
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
        audioProduction.enable = true;
        gaming.enable = true;
        virtualReality.enable = true;
        debug.enable = true;
      };
    };
  };
}
