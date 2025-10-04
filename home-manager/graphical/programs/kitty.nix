{
  lib,
  config,
  pkgs,
  ...
}: {
  custom.graphical.desktopAgnostic = let
    kitty = lib.getExe config.programs.kitty.package;
  in {
    terminalEmulatorCommand = "${kitty}";
    extraCommands.terminalEmulator = kitty;
  };
  programs.kitty = lib.mkForce {
    font = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrains Mono Nerd Font";
      size = 14;
    };
    keybindings = {
    };
    settings = {
      shell = "${pkgs.nushell}/bin/nu";
      confirm_os_window_close = 0;
      enable_audio_bell = false;
      visual_bell_duration = 0.25;
      visual_bell_color = "#555555";
      scrollback_pager = ''${lib.getExe config.custom.nixvim.finalPackage} -c "silent write! /tmp/kitty_scrollback_buffer | te cat /tmp/kitty_scrollback_buffer - " -c "$"'';
    };
  };
}
