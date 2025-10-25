{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.custom.notes.enable {
    home.shellAliases = let
      dir = config.custom.notes.location;
    in {
      n = ''zk --working-dir="${dir}"'';
      nd = ''zk --working-dir="${dir}" daily'';
    };

    programs.zk = {
      enable = true;
      settings = {
        note = {
          language = "en";
          default-title = "untitled";
          extension = "md";
          id-charset = "alphanum";
          id-length = 4;
          id-case = "lower";
        };
        extra = {
          author = config.home.username;
        };
        format.markdown = {
          hashtags = true;
        };
        lsp-diagnostics = {
          wiki-title = "hint";
          dead-link = "error";
        };
        group.daily = {
          paths = ["daily"];
          note = {
            filename = "{{format-date now}}";
            #template = "daily.md";
          };
        };
        alias = {
          daily = "mkdir -p $ZK_NOTEBOOK_DIR/daily;zk new --no-input \"$ZK_NOTEBOOK_DIR/daily\"";
        };
      };
    };

    custom.notes = {
      sync = lib.mkIf config.custom.secrets.enable {
        enable = true;
        remote = "git@notes.git:silvarc141/notes.git";
      };
    };

    programs.ssh.matchBlocks = lib.mkIf config.custom.secrets.enable {
      "notes.git" = {
        hostname = "github.com";
        user = "git";
        identityFile = config.sops.secrets.ssh-notes-rw.path;
      };
    };

    sops.secrets.ssh-notes-rw = lib.mkIf config.custom.secrets.enable {};

    custom.ephemeral.data = {
      directories = [config.custom.notes.location];
    };
  };
}
