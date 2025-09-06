{
  lib,
  config,
  pkgs,
  ...
}: {
  options.custom.printing.enable = lib.mkEnableOption "enable printing configuration";

  config = lib.mkIf config.custom.printing.enable {
    services = {
      printing = {
        enable = true;
        drivers = [pkgs.hplip];
      };
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
    };
    custom.ephemeral = {
      data.directories = [
        "/etc/printcap"
        "/var/lib/cups"
      ];
    };
    # hardware.printers = {
    #   ensureDefaultPrinter = "";
    #   ensurePrinters = [
    #     {
    #       name = "Dell_1250c";
    #       location = "Home";
    #       deviceUri = "http://192.168.178.2:631/printers/Dell_1250c";
    #       model = "drv:///sample.drv/generic.ppd";
    #       ppdOptions = {
    #         PageSize = "A4";
    #       };
    #     }
    #   ];
    # };
  };
}
