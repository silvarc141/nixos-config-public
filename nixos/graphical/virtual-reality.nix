{
  pkgs,
  config,
  lib,
  ...
}: {
  options.custom.graphical.virtualReality.enable = lib.mkEnableOption "virtual reality configuration and tools";

  config = lib.mkIf config.custom.graphical.virtualReality.enable {
    services.wivrn = {
      enable = true;
      package = pkgs.wivrn.overrideAttrs (previousAttrs: {
        patches =
          (previousAttrs.patches or [])
          ++ [
            ./do-not-move-openvr-config.diff
          ];
      });
      autoStart = true;
      openFirewall = true;
      config = {
        enable = true;
        json = {
          application = [pkgs.wlx-overlay-s];
          scale = 0.5;
          bitrate = 100000000;
        };
      };
    };
    environment.systemPackages = with pkgs; [opencomposite];
  };
}
