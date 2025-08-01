{
  description = "silvarc's nix config flake";

  inputs = {
    # nixpkgs
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # nixpkgs-mobile-bootstrap.url = "github:nixos/nixpkgs/0258808f5744ca980b9a1f24fe0b1e6f0fecee9c";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-24-11.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-24-05.url = "github:nixos/nixpkgs/nixos-24.05";

    # unstable
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    mobile-nixos = {
      url = "github:/mobile-nixos/mobile-nixos/7a5fb89f4d2f08829f3fa1078108ceb40e8c8a67";
      flake = false;
    };

    # stable
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    reapkgs-known = {
      url = "github:silvarc141/reapkgs-known";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    reapkgs-extended = {
      url = "github:silvarc141/reapkgs-extended";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    hyprgrass = {
      url = "github:horriblename/hyprgrass/51da8d137e042c117fe46a5c019ec38c0de0342a";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    # frozen
    nixos-hardware.url = "github:NixOS/nixos-hardware/cc66fddc6cb04ab479a1bb062f4d4da27c936a22";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/refs/tags/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs-stable";
      inputs.pre-commit-hooks-nix.follows = "git-hooks";
    };
    disko = {
      url = "github:nix-community/disko/refs/tags/v1.11.0";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    impermanence = {
      url = "github:nix-community/impermanence/4b3e914cdf97a5b536a889e939fb2fd2b043a170";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/refs/tags/2411.6.0";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    catppuccin = {
      url = "github:catppuccin/nix/refs/tags/v1.2.1";
    };
    musnix = {
      url = "github:musnix/musnix/d56a15f30329f304151e4e05fa82264d127da934";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    qrookie = {
      url = "github:glaumar/QRookie/refs/tags/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs-24-05";
      inputs.home-manager.follows = "home-manager";
    };

    # workaround for "transitive inputs not in registry" (https://github.com/NixOS/nix/issues/5790)
    git-hooks = {
      url = "github:cachix/git-hooks/80479b6ec16fefd9c1db3ea13aeb038c60530f46";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
  };

  outputs = {...} @ args: (import ./init.nix args);
}
