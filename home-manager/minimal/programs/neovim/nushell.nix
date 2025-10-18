{
  lib,
  config,
  pkgs,
  ...
}: {
  config = lib.mkIf config.custom.nixvim.enable {
    programs.nixvim = {
      opts = lib.mkIf config.programs.nushell.enable {
        shell = "${pkgs.nushell}/bin/nu";
        shellcmdflag = "--login --stdin --no-newline -c";
        shellredir = "out+err> %s";
        shellpipe = "| complete | update stderr { ansi strip } | tee { get stderr | save --force --raw %s } | into record";
        shelltemp = false;
        shellxescape = "";
        shellxquote = "";
        shellquote = "";
      };
    };
  };
}
