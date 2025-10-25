{
  lib,
  config,
  pkgs,
  ...
}: {
  # To find device paths/buttons, [sudo] nix run nixpkgs#evtest
  services.nix-ghkd = lib.mkIf config.services.nix-ghkd.enable {
    devices = {
      EightBitDoPro2 = {
        enable = true;
        devicePath = "/dev/input/by-id/usb-8BitDo_8BitDo_Pro_2_000000000003-event-joystick";
        buttons = [
          {
            buttonCode = 316; # heart
            command = "hyprctl dispatch global kando:main";
            packages = [pkgs.hyprland];
          }
          {
            buttonCode = 306; # back
            command = "hyprctl dispatch global kando:main";
            packages = [pkgs.hyprland];
          }
          {
            buttonCode = 309; # back
            command = "hyprctl dispatch global kando:main";
            packages = [pkgs.hyprland];
          }
          {
            buttonCode = 319; # ?
            command = "hyprctl dispatch global kando:main";
            packages = [pkgs.hyprland];
          }
        ];
      };
    };
  };
}
