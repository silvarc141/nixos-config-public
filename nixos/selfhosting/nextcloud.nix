{
  lib,
  config,
  pkgs,
  paths,
  ...
}: {
  config = lib.mkIf config.services.nextcloud.enable {
    services = {
      nextcloud = {
        package = pkgs.nextcloud30;
        hostName = config.custom.tailscale.fullNodeAddress;
        home = "/storage/nextcloud";
        datadir = "/var/lib/nextcloud";
        # configureRedis = true;
        # https = true;
        database.createLocally = true;
        maxUploadSize = "16G";
        appstoreEnable = true;
        extraApps = with pkgs.nextcloud30Packages.apps; {
          inherit calendar contacts mail notes tasks;
        };
        config = {
          dbtype = "mysql";
          adminuser = "admin";
          adminpassFile = config.sops.secrets.nextcloud-password-admin.path;
        };
        settings = {
          trusted_domains = [
            "localhost"
            "127.0.0.1"
            config.networking.hostName
          ];
          default_phone_region = "PL";
          # overwriteprotocol = "https";
        };
      };
      # onlyoffice = {
      #   enable = true;
      #   hostname = "";
      # };
      # nginx.virtualHosts = {
      #   ${config.services.nextcloud.hostName} = {
      #     forceSSL = true;
      #     enableACME = true;
      #   };
      #   ${config.services.onlyoffice.hostName} = {
      #     forceSSL = true;
      #     enableACME = true;
      #   };
      # };
    };
    # security.acme = {
    #   acceptTerms = true;
    #   certs = {
    #     ${config.services.nextcloud.hostName}.email = "";
    #   };
    # };
    sops.secrets.nextcloud-password-admin = {
      sopsFile = paths.secrets + "/server.yaml";
      mode = "0440";
      owner = "nextcloud";
      group = "nextcloud";
    };
    custom.ephemeral = {
      data.directories = [
        config.services.nextcloud.home
        config.services.nextcloud.datadir
      ];
    };
  };
}
