{pkgs, ...}: {
  custom = {
    graphical = {
      enable = true;
      windowManager = "hyprland";
    };
    secrets.enable = true;
    ephemeral.enable = true;
    audio.maxVolume = 120;
    screen.initialBrightness = 10;
    presets = {
      minimal = {
        shell.enable = true;
        dev.enable = true;
      };
      graphical = {
        basics.enable = true;
        generalDevelopment.enable = true;
        gameDevelopment.enable = true;
        audioProduction.enable = true;
      };
    };
  };
  programs = {
    wl-kbptr.enable = true;
    steam.enable = true;
    lutris.enable = true;
    qrookie.enable = true;
  };
  services = {
    activitywatch.enable = true;
    # fails to build
    # wivrn.enable = true;
  };
  home.packages = with pkgs; [
    lilv
    deepfilternet
  ];
}
