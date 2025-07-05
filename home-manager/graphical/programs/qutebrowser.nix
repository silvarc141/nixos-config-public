{
  config,
  lib,
  ...
}: {
  programs.qutebrowser = lib.mkIf config.programs.qutebrowser.enable {
    settings = {
      colors.webpage.darkmode.enabled = true;
      content.blocking.enabled = true;
    };
  };
}
