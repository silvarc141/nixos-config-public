{
  config,
  lib,
  outputs,
  pkgs,
  ...
}: {
  imports = [
    ./graphical
    ./commands
    ./git.nix
    ./nixvim.nix
    ./bash.nix
    ./zk.nix
    ./impermanence.nix
  ];

  commands = {
    rebuild.enable = true;
  };

  programs.home-manager.enable = true;
  programs.ssh.enable = true;

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
    ];
  };

  home = {
    stateVersion = "23.11";
    username = lib.mkDefault config.singleUser.name;
    homeDirectory = "/home/${config.home.username}";
  };

  home.sessionVariables = {
    FLAKE = "$HOME/nixos-config";
    #XDG_DESKTOP_DIR = "$HOME/desktop";
    #XDG_DOCUMENTS_DIR = "$HOME/documents";
    XDG_DOWNLOAD_DIR = "$HOME/downloads";
    #XDG_MUSIC_DIR = "$HOME/music";
    #XDG_PICTURES_DIR = "$HOME/pictures";
    #XDG_PUBLICSHARE_DIR = "$HOME/public";
    #XDG_TEMPLATES_DIR = "$HOME/templates";
    #XDG_VIDEOS_DIR = "$HOME/videos";
  };

  home.packages = with pkgs; [
    pciutils
    usbutils
    inetutils
    nmap
    killall
    tldr
    distrobox
  ];
}
