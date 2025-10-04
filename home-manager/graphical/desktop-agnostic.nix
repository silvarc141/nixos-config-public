{
  pkgs,
  lib,
  ...
}: {
  options.custom.graphical.desktopAgnostic = let
    commands = [
      "launcher"
      "powerMenu"
      "textEditor"
      "fileManager"
      "terminalEmulator"
      "browser"

      "forceKillWindow"

      "movePointerInActiveWindow"
      "cancelMovePointer"
      "simulateLeftClick"
      "simulateDoubleClick"
      "simulateRightClick"
      "simulateMiddleClick"
      "simulateScrollUp"
      "simulateScrollDown"

      "passwordManagerOpen"
      "passwordManagerLock"
      "passwordManagerSelect"
      "passwordManagerSelectTOTP"

      "screenshotRegionToClipboard"
      "screenshotActiveWindowToClipboard"
      "annotateImageFromClipboard"
      "saveClipboardAsPNG"
      "clipboardHistorySelect"
      "clipboardHistoryWipe"

      "volumeUp"
      "volumeDown"
      "volumeMuteToggle"
      "micMuteToggle"

      "brightnessUp"
      "brightnessDown"
      "brightnessDim"
      "brightnessUndim"
      "screenLock"
      "screenOff"
      "screenOn"

      "movePointerLeft"
      "movePointerRight"
      "movePointerUp"
      "movePointerDown"
    ];
    mkCommandOption = name:
      lib.mkOption {
        type = lib.types.str;
        default = "${pkgs.libnotify}/bin/notify-send -a System 'Command ${name} not set!'";
        description = "Additional command to be implemented by a desktop program and invoked by window managers or wayland compositors";
      };
  in {
    extraCommands = lib.genAttrs commands mkCommandOption;
    terminalEmulatorCommand = lib.mkOption {
      type = lib.types.str;
      description = "Command used for executing CLI programs from launchers";
    };
    dmenuCommand = lib.mkOption {
      type = lib.types.str;
      description = "dmenu-compatible command used for pickers";
    };
  };
}
