{
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf config.programs.neovide.enable {
    custom.graphical.desktopAgnostic.extraCommands.textEditor = "${pkgs.neovide}/bin/neovide";
    custom.graphical.defaultApps.textEditor = "neovide.desktop";
    programs.neovide.settings = {
      vsync = true;
    };
    xdg.desktopEntries = {
      nvim = {
        name = "nvim";
        noDisplay = true;
      };
      vim = {
        name = "vim";
        noDisplay = true;
      };
      gvim = {
        name = "gvim";
        noDisplay = true;
      };
    };
    custom.ephemeral = {
      local = {
        files = [".local/share/neovide/neovide-settings.json"];
      };
    };
  };
}
