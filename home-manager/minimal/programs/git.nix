{
  lib,
  config,
  ...
}: let
  gitAliases = {
    g = "git";
    gs = "git status";
    gss = "git status -s";
    gd = "git diff";
    gdc = "git diff --cached";
    gl = "git log";
    gl1 = "git log --oneline";
    glp = "git log -p --ext-diff";
    ga = "git add";
    gaa = "git add -A";
    gc = "git commit";
    gcn = "git commit --amend";
    gcm = "git commit -m";
    gcam = "git commit -am";
    gp = "git push";
    gpl = "git pull";
  };
in {
  config = lib.mkIf config.programs.git.enable {
    programs.git = {
      userName = "silvarc141";
      userEmail = "silvarc141@users.noreply.github.com";
      lfs.enable = true;
      difftastic = {
        enable = true;
      };
      ignores = [
        "*~"
        "*.swp"
        "*.swo"
        "*.Trash*"

        "*.log"
        "result"
        ".envrc"
        ".direnv"
      ];
      extraConfig = {
        core = {
          autocrlf = "input";
        };
        init.defaultBranch = "main";
        help.autocorrect = 10;
        push.autoSetupRemote = true;
      };
    };

    programs.bash.shellAliases = gitAliases;
    programs.nushell.shellAliases = gitAliases;
    programs.lazygit.enable = true;
    programs.gh.enable = true;
    custom.ephemeral.data = {
      files = [
        ".config/gh/hosts.yml"
      ];
    };
  };
}
