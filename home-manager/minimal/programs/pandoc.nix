{
  lib,
  config,
  pkgs,
  ...
}: {
  config = lib.mkIf config.programs.pandoc.enable {
    # home.packages = with pkgs; [
    #   (pkgs.python312.withPackages (p: with p; [weasyprint]))
    #   texliveSmall
    # ];
  };
}
