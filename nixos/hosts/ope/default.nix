{
  config,
  pkgs,
  ...
}: {
  custom = {
    mobile.enable = true;
    remoteAccess.enable = true;
    mainUser = {
      homeType = "minimal";
    };
  };
  hardware = {
    sensor.iio.enable = true;
    # graphics.enable = true;
  };

  zramSwap.enable = true;

  users.users.${config.custom.mainUser.name}.extraGroups = [
    "feedbackd"
    "video"
  ];

  services.gnome.gnome-keyring.enable = true;

  services.xserver.desktopManager.phosh = {
    enable = true;
    user = config.custom.mainUser.name;
    group = "users";
  };

  programs.calls.enable = true;

  environment.systemPackages = with pkgs; [
    gnome-console
    megapixels
    epiphany
    chatty
  ];
}
