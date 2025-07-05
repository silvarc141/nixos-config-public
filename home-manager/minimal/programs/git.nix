{
  lib,
  config,
  ...
}: let
  gitAliases = {
    g = "git";
    gs = "git status -s";
    gd = "git diff";
    gl = "git log";
    glp = "git log -p --ext-diff";
    "g?" = "git log -p --ext-diff";
    ga = "git add";
    gaa = "git add -A";
    gc = "git commit";
    gcm = "git commit -m";
    gcam = "git commit -am";
    gp = "git push";
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
