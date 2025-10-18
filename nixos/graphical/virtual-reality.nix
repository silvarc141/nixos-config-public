{
  pkgs,
  config,
  lib,
  ...
}: {
  options.custom.graphical.virtualReality.enable = lib.mkEnableOption "virtual reality configuration and tools";

  config = lib.mkIf config.custom.graphical.virtualReality.enable {
    networking.firewall = {
      # for steamvr
      allowedTCPPorts = [27036 27037];
      allowedUDPPorts = [27031 27036 10400 10401];
    };
    services.wivrn = {
      enable = true;
      autoStart = true;
      openFirewall = true;
      defaultRuntime = true;
      config = {
        enable = true;
        json = {
          # application = [pkgs.wlx-overlay-s];
          scale = 0.5;
          bitrate = 100000000;
        };
      };
    };
    environment.systemPackages = with pkgs; [
      wlx-overlay-s
      android-tools
      opencomposite
    ];
    # this does not seem to work
    # programs.steam.package = lib.mkDefault (
    #   pkgs.steam.override (prev: {
    #     extraEnv =
    #       {
    #         PRESSURE_VESSEL_FILESYSTEMS_RW = "$XDG_RUNTIME_DIR/wivrn/comp_ipc";
    #         # PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES = 1;
    #         # WAYLAND_DISPLAY = "";
    #         # QT_QPA_PLATFORM = "xcb";
    #         # GDK_BACKEND = "x11";
    #       }
    #       // (prev.extraEnv or {});
    #   })
    # );
  };
}
