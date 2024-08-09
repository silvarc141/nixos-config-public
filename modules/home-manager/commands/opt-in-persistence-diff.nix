{
  lib,
  config,
  pkgs,
  ...
}:
with lib; {
  options.commands.optInPersistenceDiff.enable = mkEnableOption "enable opt-in-persistence-diff command";

  config = mkIf config.commands.optInPersistenceDiff.enable {
    home.packages = with pkgs; [
      (writeShellScriptBin "opt-in-persistence-diff" ''
        sudo ${fd}/bin/fd --one-file-system --base-directory / --type f --hidden --exclude "{\
        tmp,\
        etc/passwd,\
        etc/group,\
        etc/.clean,\
        etc/.updated,\
        etc/NIXOS,\
        etc/machine-id,\
        etc/resolv.conf,\
        etc/resolvconf.conf,\
        etc/shadow,\
        etc/sudoers,\
        etc/subgid,\
        etc/subuid,\
        root/.cache,\
        root/.nix-channels,\
        var/.updated,\
        var/lib/logrotate.status,\
        var/lib/systemd,\
        var/lib/NetworkManager,\
        var/lib/tailscale,\
        home/silvarc/.cache,\
        home/silvarc/.config/dconf/user,\
        home/silvarc/.config/pulse/cookie,\
        home/silvarc/.local/state/lesshst,\
        home/silvarc/.local/state/nvim/shada/main.shada,\
        **/com.1password.1password.json\
        }"'')
    ];
  };
}
