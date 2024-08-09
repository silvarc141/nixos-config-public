{...}: {
  programs.git = {
    enable = true;
    userName = "silvarc141";
    userEmail = "silvarc141@users.noreply.github.com";
    lfs.enable = true;
    difftastic = {
      enable = true;
    };
    ignores = ["*.swp"];
    extraConfig = {
      core = {
        autocrlf = "input";
      };
      init.defaultBranch = "main";
      help.autocorrect = 10;
    };
  };

  home.shellAliases = {
    g = "git";
    gs = "git status";
    gd = "git diff";
    gl = "git log";
    glp = "git log -p | bat";
    ga = "git add";
    gaa = "git add *";
    gc = "git commit";
    gcm = "git commit -m";
    gcam = "git commit -am";
    gp = "git push";
  };

  programs.gh.enable = true;
  programs.lazygit.enable = true;
}
