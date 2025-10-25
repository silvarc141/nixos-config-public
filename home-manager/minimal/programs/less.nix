{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.programs.less.enable {
    programs = {
      less = {
        keys = ''
        '';
      };
      # lesspipe.enable = true;
    };
    home.sessionVariables = {
      # enable wrapping in journalctl
      SYSTEMD_LESS = "FRXMK";
      PAGER = "less -iFXMK";
    };
    custom.ephemeral = {
      local = {
        directories = [
          ".local/state/lesshst"
        ];
        files = [
          ".local/state/lesshsQ"
        ];
      };
    };
  };
}
