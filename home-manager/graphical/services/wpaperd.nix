{
  lib,
  config,
  paths,
  ...
}: {
  config = lib.mkIf config.services.wpaperd.enable {
    services.wpaperd.settings = {
      eDP-1 = {
        path = "${paths.assets}/bliss-night.webp";
      };
    };
    # systemd.user.services.wpaperd = {
    #   Install = {WantedBy = [config.wayland.systemd.target];};
    #   Unit = {
    #     ConditionEnvironment = "WAYLAND_DISPLAY";
    #     Description = "wpaperd";
    #     After = [config.wayland.systemd.target];
    #     PartOf = [config.wayland.systemd.target];
    #   };
    #   Service = {
    #     ExecStart = lib.getExe config.programs.wpaperd.package;
    #     Restart = "always";
    #     RestartSec = "10";
    #   };
    # };
  };
}
