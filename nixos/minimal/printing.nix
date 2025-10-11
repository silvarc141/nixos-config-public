{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.custom;
  sharing = cfg.printing.sharing.enable;
in {
  options.custom.printing = {
    enable = mkEnableOption "printing configuration";
    sharing.enable = mkEnableOption "printer sharing";
  };

  config = mkIf config.custom.printing.enable {
    services = {
      printing = {
        enable = true;
        drivers = [pkgs.hplip];

        listenAddresses = mkIf sharing ["*:631"];
        allowFrom = mkIf sharing ["all"];
        browsing = mkIf sharing true;
        defaultShared = mkIf sharing true;
        openFirewall = mkIf sharing true;
      };
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
        publish = mkIf sharing {
          enable = true;
          userServices = true;
        };
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
