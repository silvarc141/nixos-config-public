{
  config,
  lib,
  pkgs,
  ...
}: {
  options.programs.yabridge.enable = lib.mkEnableOption "yabridge Windows VST Wine-based compatibility layer";

  config = lib.mkIf config.programs.yabridge.enable {
    home.packages = with pkgs; [
      yabridge
      yabridgectl
    ];

    custom.ephemeral.data = {
      directories = [
        ".config/yabridgectl"
        ".vst/yabridge"
        ".vst3/yabridge"
        ".wine" # this shouldn't really be here
      ];
    };
  };
}
