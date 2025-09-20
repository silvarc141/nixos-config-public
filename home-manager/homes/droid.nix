{...}: {
  custom.presets.minimal.shell.enable = true;

  programs = {
    git.enable = true;
    ssh.enable = true;
    direnv.enable = true;
    android-tools.enable = true;
  };
}
