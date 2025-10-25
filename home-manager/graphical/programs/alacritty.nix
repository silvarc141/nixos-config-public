{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.programs.alacritty.enable {
    custom.graphical.desktopAgnostic = let
      alacritty = lib.getExe pkgs.alacritty;
    in {
      terminalEmulatorCommand = "${alacritty} -e";
      extraCommands.terminalEmulator = alacritty;
    };
    programs.alacritty = {
      settings = {
        font.size = 15;
        terminal.shell.program = "${pkgs.nushell}/bin/nu";
      };
    };
  };
}
