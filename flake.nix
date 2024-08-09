{
  description = "silvarc's NixOS and Home Manager config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    impermanence.url = "github:nix-community/impermanence";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    nix-on-droid.url = "github:nix-community/nix-on-droid/release-24.05";
    nix-on-droid.inputs.nixpkgs.follows = "nixpkgs-stable";

    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    nix-on-droid,
    ...
  } @ inputs: let
    inherit (self) outputs;
    forAllSystems = nixpkgs.lib.genAttrs systems;
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
    ];
    nixosConfig = outputs.config;
  in {
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
    overlays = import ./overlays {inherit inputs;};

    nixosConfigurations = let
      mkHost = name: {
        inherit name;
        value = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs outputs nixosConfig;};
          modules = [
            ./modules/nixos
            home-manager.nixosModules.home-manager
            (import (./. + "/hosts/${name}/configuration.nix"))
            ({config, ...}: {
              networking.hostName = name;
            })
          ];
        };
      };
    in
      builtins.listToAttrs [
        (mkHost "ggb")
        (mkHost "thp")
        (mkHost "hsv")
        (mkHost "wsl")
      ];

    homeConfigurations = let
      mkHome = name: {
        value = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {inherit inputs outputs;};
          modules = [(import (./. + "/home-manager/${name}.nix"))];
        };
      };
    in
      builtins.listToAttrs [
        (mkHome "silvarc")
        (mkHome "wslivarc")
      ];
    
    nixOnDroidConfigurations.default = nix-on-droid.lib.nixOnDroidConfiguration {
      pkgs = import nixpkgs { 
        system = "aarch64-linux"; 
        overlays = [
          nix-on-droid.overlays.default
          (import ./overlays {inherit inputs;})
        ];
      };
      modules = [ ./hosts/nod/configuration.nix ];
      home-manager-path = home-manager.outPath;
    };
  };
}
