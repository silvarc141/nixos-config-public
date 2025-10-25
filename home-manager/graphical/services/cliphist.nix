{
  lib,
  config,
  pkgs,
  ...
}: {
  config = lib.mkIf config.services.cliphist.enable {
    custom.graphical.desktopAgnostic.extraCommands = let
      cliphist = lib.getExe pkgs.cliphist;
      wl-copy = "${pkgs.wl-clipboard}/bin/wl-copy";
      dmenu = config.custom.graphical.desktopAgnostic.dmenuCommand;
    in {
      clipboardHistorySelect = lib.mkDefault "${cliphist} list | ${dmenu} | ${cliphist} decode | ${wl-copy}";
      clipboardHistoryWipe = "${cliphist} wipe && ${pkgs.libnotify}/bin/notify-send -a System 'Clipboard history cleared'";
    };
  };
}
