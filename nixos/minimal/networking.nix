{config, ...}: {
  networking = {
    nftables.enable = true;
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
      ensureProfiles = {
        environmentFiles = [
          "/run/secrets/wifi-password-mops5"
          "/run/secrets/wifi-password-sagem"
          "/run/secrets/wifi-password-mob"
        ];
        profiles = {
          mob = {
            connection = {
              id = "mob";
              type = "wifi";
              autoconnect-priority = 5;
            };
            ipv4 = {
              method = "auto";
            };
            ipv6 = {
              addr-gen-mode = "default";
              method = "auto";
            };
            wifi = {
              mode = "infrastructure";
              ssid = "mob";
            };
            wifi-security = {
              auth-alg = "open";
              key-mgmt = "wpa-psk";
              psk = "$MOB";
            };
          };
          mops5 = {
            connection = {
              id = "mops5";
              type = "wifi";
            };
            ipv4 = {
              method = "auto";
            };
            ipv6 = {
              addr-gen-mode = "default";
              method = "auto";
            };
            wifi = {
              mode = "infrastructure";
              ssid = "mops5";
            };
            wifi-security = {
              auth-alg = "open";
              key-mgmt = "wpa-psk";
              psk = "$MOPS5";
            };
          };
          sagem = {
            connection = {
              id = "SAGEM_9739";
              type = "wifi";
            };
            ipv4 = {
              method = "auto";
            };
            ipv6 = {
              addr-gen-mode = "default";
              method = "auto";
            };
            wifi = {
              mode = "infrastructure";
              ssid = "SAGEM_9739";
            };
            wifi-security = {
              key-mgmt = "wpa-psk";
              psk = "$SAGEM";
            };
          };
        };
      };
    };
  };
  sops.secrets = {
    wifi-password-mops5 = {};
    wifi-password-sagem = {};
    wifi-password-mob = {};
  };
  users.users.${config.custom.mainUser.name}.extraGroups = ["networkmanager"];
  # to make sure wifi works
  system.activationScripts = {
    rfkillUnblockWlan = {
      text = ''
        rfkill unblock wlan
      '';
      deps = [];
    };
  };
  custom.ephemeral = {
    data.directories = [
      "/var/lib/iwd"
      "/etc/NetworkManager/system-connections"
    ];
    cache.directories = ["/var/lib/NetworkManager"];
  };
}
