{
  pkgs,
  config,
  lib,
  ...
}: let
  nixosConfigRemote = "git@nixos-config.git:silvarc141/nixos-config.git";
  nixosConfigDirRelative = "nixos";
  nixosConfigDir = "${config.home.homeDirectory}/${nixosConfigDirRelative}";
in {
  options.services.sync-nixos-config.enable = lib.mkEnableOption "enable local config repo configuration";

  config = lib.mkIf (config.services.sync-nixos-config.enable && config.custom.secrets.enable) {
    sops.secrets.ssh-nixos-config-r = {};

    programs.ssh.matchBlocks = {
      "nixos-config.git" = {
        hostname = "github.com";
        user = "git";
        identityFile = config.sops.secrets.ssh-nixos-config-r.path;
      };
    };

    systemd.user = {
      enable = true;
      services.sync-nixos-config = {
        Service = {
          ExecStart = "${pkgs.writeShellScript "sync-nixos-config" ''
            GIT=${pkgs.git}/bin/git

            if [ ! -d "${nixosConfigDir}" ]; then
              mkdir -p ${nixosConfigDir}
            fi

            cd ${nixosConfigDir}

            if [ ! -d ".git" ]; then
              $GIT init -b main
              $GIT remote add origin ${nixosConfigRemote}
              if ! $GIT fetch; then
                rm -rf .git
                echo "Git fetch failed. Removing changes and exiting."
                exit 1
              fi
              $GIT checkout -b main origin/main --force
            fi

            $GIT pull --rebase origin main --autostash
          ''}";
          Restart = "on-failure";
          RestartSec = 30;
        };
      };
      timers.sync-nixos-config = {
        Timer = {
          OnBootSec = "1min";
          OnUnitActiveSec = "5min";
          Unit = "sync-nixos-config.service";
        };
        Install.WantedBy = ["timers.target"];
      };
    };
  };
}
