{
  lib,
  config,
  pkgs,
  ...
}: {
  options.programs.krita.enable = lib.mkEnableOption "Krita, the open source painting application";

  config = lib.mkIf config.programs.krita.enable {
    home.packages = with pkgs; [krita];
    custom.ephemeral = {
      data.directories = [
        ".config/kritarc"
        ".config/kritadisplayrc"
        ".local/share/krita"
      ];
      local.files = [
        ".local/share/krita.log"
        ".local/share/krita-sysinfo.log"
      ];
    };
  };
}
