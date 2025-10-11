{
  lib,
  config,
  ...
}: {
  options.custom.tailscale = {
    suffix = lib.mkOption {
      type = lib.types.str;
      default = "ts.net";
    };
    networkName = lib.mkOption {
      type = lib.types.str;
      default = "cuscus-interval";
    };
    fullNodeAddress = lib.mkOption {
      type = lib.types.str;
      default = builtins.concatStringsSep "." [
        config.networking.hostName
        config.custom.tailscale.networkName
        config.custom.tailscale.suffix
      ];
    };
  };
  config = {
    services.tailscale = {
      enable = lib.mkDefault true;
      disableTaildrop = true;
      # TODO configure
      # permitCertUid = "";
      # useRoutingFeatures = "";
    };
    custom.ephemeral = {
      data.directories = ["/var/lib/tailscale"];
    };
  };
}
