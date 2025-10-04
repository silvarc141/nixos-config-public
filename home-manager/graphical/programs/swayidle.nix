{
  lib,
  config,
  pkgs,
  ...
}: {
  config = let
    cmds = config.custom.graphical.desktopAgnostic.extraCommands;

    systemctl = "${pkgs.systemd}/bin/systemctl";
    lsblk = "${pkgs.util-linux}/bin/lsblk";
    grep = "${pkgs.gnugrep}/bin/grep";
    notify-send = "${pkgs.libnotify}/bin/notify-send";
    nmcli = "${pkgs.networkmanager}/bin/nmcli";

    lockBasic = builtins.concatStringsSep " && " [cmds.passwordManagerLock cmds.clipboardHistoryWipe];
    lockFull = builtins.concatStringsSep " && " [cmds.passwordManagerLock cmds.clipboardHistoryWipe cmds.screenLock];
    hibernateOrShutdown = "${systemctl} hibernate || ${systemctl} poweroff";

    # locally safe = no immediate untrusted access to local machine (i.e. in your home)
    # should only influence timers, not authentication methods
    # TODO: expand to handle all declarative wifi connections and optionally verify if KEY drive contains correct decryption key
    localSafeCondition = "(${nmcli} device show wlan0 | ${grep} -e 'GENERAL.CONNECTION.*mops5' -e 'GENERAL.CONNECTION.*SAGEM_9739' &>/dev/null) || (${lsblk} -o label | ${grep} 'KEY' &>/dev/null)";

    debugMode = false;
    mkTime = time:
      if debugMode
      then time / 10
      else time;
    mkCommand = cmd:
      if debugMode
      then "${notify-send} 'Executing: ${cmd}'"
      else cmd;
    mkCommandUnsafeOnly = cmd:
      if debugMode
      then "(${localSafeCondition} && ${notify-send} 'Safe, NOT executing unsafe-only: ${cmd}') || ${notify-send} 'Unsafe, executing unsafe-only: ${cmd}' "
      else "${localSafeCondition} || (${cmd})";
    mkCommandSafeOnly = cmd:
      if debugMode
      then "(${localSafeCondition} && ${notify-send} 'Safe, executing safe-only: ${cmd}') || ${notify-send} 'Unsafe, NOT executing safe-only: ${cmd}' "
      else "${localSafeCondition} && (${cmd})";
  in {
    services.swayidle = lib.mkIf config.services.swayidle.enable {
      events = [
        {
          event = "before-sleep";
          command = lockFull;
        }
        {
          event = "lock";
          command = lockFull;
        }
        {
          event = "after-resume";
          command = cmds.brightnessUndim;
        }
      ];
      timeouts = [
        # safe
        {
          timeout = mkTime 240;
          command = mkCommand cmds.brightnessDim;
          resumeCommand = mkCommand cmds.brightnessUndim;
        }
        {
          timeout = mkTime 300;
          command = mkCommand cmds.screenOff;
          resumeCommand = mkCommand cmds.screenOn;
        }
        {
          timeout = mkTime 300;
          command = mkCommand lockBasic;
        }
        {
          timeout = mkTime 10800;
          command = mkCommand hibernateOrShutdown;
        }

        # unsafe
        {
          timeout = mkTime 10; # super short for idle timer, additionally should have an idle-independent timer
          command = mkCommandUnsafeOnly lockBasic;
        }
        {
          timeout = mkTime 30;
          command = mkCommandUnsafeOnly cmds.brightnessDim;
          resumeCommand = mkCommandUnsafeOnly cmds.brightnessUndim;
        }
        {
          timeout = mkTime 45;
          command = mkCommandUnsafeOnly cmds.screenOff;
          resumeCommand = mkCommandUnsafeOnly cmds.screenOn;
        }
        {
          timeout = mkTime 60;
          command = mkCommandUnsafeOnly hibernateOrShutdown;
        }
      ];
    };
  };
}
