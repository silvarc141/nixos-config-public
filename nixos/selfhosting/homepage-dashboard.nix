{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.services.homepage-dashboard.enable {
    services.homepage-dashboard = {
      openFirewall = true;
      allowedHosts = "192.168.8.2:8082";
      widgets = [
        {
          glances = {
            url = "http://192.168.8.2:61208";
            version = 4;
            cputemp = true;
            uptime = true;
            disk = "/storage";
            expanded = true;
          };
        }
      ];
    };
    services.glances = {
      enable = true;
      openFirewall = true;
    };
  };
}
