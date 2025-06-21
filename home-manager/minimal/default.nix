{
  config,
  overlays,
  lib,
  ...
}: {
  imports = lib.custom.getImportable ./.;

  home.stateVersion = "23.11";
  home.homeDirectory = lib.mkDefault "/home/${config.home.username}";
  home.username = lib.mkDefault "silvarc";
  programs.home-manager.enable = true;

  nixpkgs = {
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
