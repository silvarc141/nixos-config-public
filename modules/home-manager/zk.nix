{...}:{
  home.shellAliases = {
    n = "zk --working-dir=$HOME/notes";
    nd = "zk --working-dir=$HOME/notes daily";
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
        author = "silvarc";
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
}
