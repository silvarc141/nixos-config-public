{...}: {
  programs.qutebrowser = {
    enable = true;
    settings = {
      colors.webpage.darkmode.enabled = true;
      content.blocking.enabled = true;
    };
  };
}
