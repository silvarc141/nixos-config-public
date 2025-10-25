{
  config,
  overlays,
  lib,
  customUtils,
  isNixosModule ? false,
  ...
}: {
  imports = customUtils.getImportable ./.;

  home.stateVersion = "23.11";
  home.homeDirectory = lib.mkDefault "/home/${config.home.username}";
  home.username = lib.mkDefault "silvarc";
  programs.home-manager.enable = true;

  nixpkgs = lib.mkIf (!isNixosModule) {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
    overlays = overlays;
  };

  xdg.configFile."nixpkgs/config.nix".text = ''
    {
      allowUnfree = true;
      allowUnfreePredicate = pkg: true;
    }
  '';
}
