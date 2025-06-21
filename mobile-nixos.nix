{
  config,
  lib,
  pkgs,
  ...
}: let
  defaultUserName = "silvarc";
in {
  config = {
    # users.users."${defaultUserName}" = {
    #   isNormalUser = true;
    #   password = "1234";
    #   extraGroups = [
    #     "dialout"
    #     "feedbackd"
    #     "networkmanager"
    #     "video"
    #     "wheel"
    #   ];
    # };

    # services.xserver.desktopManager.phosh = {
    #   user = defaultUserName;
    #   enable = true;
    #   group = "users";
    # };

    # services.brltty.enable = false;
    # services.orca.enable = false;

    # mobile.boot.stage-1.kernel.useStrictKernelConfig = lib.mkDefault true;

    # mobile.beautification = {
    #   silentBoot = true;
    #   splash = true;
    # };

    # programs.calls.enable = true;

    # environment.systemPackages = with pkgs; [
    #   chatty              # IM and SMS
    #   epiphany            # Web browser
    #   gnome-console       # Terminal
    #   megapixels          # Camera
    # ];

    # hardware.sensor.iio.enable = true;
  };
}
