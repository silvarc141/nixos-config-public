{
  pkgs,
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.programs.pidgin.enable {
    programs.pidgin.plugins = with pkgs.pidginPackages; [
      purple-discord
      purple-facebook
      pidgin-opensteamworks
      # purple-matrix # issue with olm https://github.com/NixOS/nixpkgs/issues/336052
    ];
  };
}
