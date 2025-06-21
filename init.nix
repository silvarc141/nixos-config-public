{
  nixpkgs-unstable,
  nixpkgs-stable,
  home-manager,
  nix-on-droid,
  ...
} @ inputs: let
  nixosHosts = [
    {
      name = "ggb";
      system = "x86_64-linux";
    }
    {
      name = "dta";
      system = "x86_64-linux";
    }
    {
      name = "thp";
      system = "x86_64-linux";
    }
    {
      name = "hsv";
      system = "x86_64-linux";
    }
    {
      name = "wsl";
      system = "x86_64-linux";
    }
  ];

  droidHosts = [
    {
      name = "nod";
      system = "aarch64-linux";
    }
  ];

  darwinHosts = [];

  homes = [
    "minimal"
    "workstation"
    "server"
    "wsl"
    "droid"
  ];

  hosts = nixosHosts ++ droidHosts ++ darwinHosts;

  defaultLib = nixpkgs-stable.lib;

  mkExtendedLib = nixpkgs: system:
    nixpkgs.lib.extend (final: prev: ({
        custom = import ./lib {
          inherit paths;
          pkgs = nixpkgs.legacyPackages.${system};
          lib = prev;
        };
      }
      // home-manager.lib // nix-on-droid.lib));

  allOverlays = with defaultLib;
    genAttrs allSystems (system: let
      lib = mkExtendedLib nixpkgs-stable system;
      pkgsStable = nixpkgs-stable.legacyPackages.${system};
      pkgsUnstable = nixpkgs-unstable.legacyPackages.${system};
    in [
      (final: prev: (import ./pkgs {
        inherit lib;
        pkgs = final;
      }))
      (final: prev: (import ./overlays {
        inherit lib pkgsStable pkgsUnstable;
        pkgsFinal = final;
        pkgsPrev = prev;
      }))
    ]);

  allSystems = with defaultLib; unique (catAttrs "system" hosts);

  paths = {
    homeManagerConfig = ./home-manager;
    secrets = ./secrets;
    assets = ./assets;
  };

  mkNixos = {
    name,
    system,
  }: let
    nixpkgs = nixpkgs-stable;
    overlays = allOverlays.${system};
    lib = mkExtendedLib nixpkgs system;
    pkgsUnstable = nixpkgs-stable.legacyPackages.${system};
  in {
    inherit name;
    value = lib.nixosSystem {
      specialArgs = {
        inherit inputs overlays pkgsUnstable paths;
        hostName = name;
      };
      modules = [./nixos];
    };
  };

  mkDroid = {
    name,
    system,
  }: let
    nixpkgs = nixpkgs-stable;
    overlays = allOverlays.${system};
    lib = mkExtendedLib nixpkgs system;
  in {
    inherit name;
    value = lib.nixOnDroidConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      extraSpecialArgs = {
        inherit inputs overlays paths lib;
        hostName = name;
      };
      modules = [./nix-on-droid];
      home-manager-path = home-manager.outPath;
    };
  };

  mkHome = name: let
    system = "x86_64-linux";
    nixpkgs = nixpkgs-stable;
    overlays = allOverlays.${system};
    lib = mkExtendedLib nixpkgs system;
  in {
    inherit name;
    value = lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      extraSpecialArgs = {
        inherit lib inputs overlays paths;
        homeType = name;
      };
      modules = [./home-manager];
    };
  };

  # mobileNixosPackages = {
  #   aarch64-linux.mobile-nixos =
  #     (import mobile-nixos {
  #       device = "oneplus-enchilada";
  #       pkgs = nixpkgs-unstable.legacyPackages.aarch64-linux;
  #       configuration = ./mobile-nixos-configuration.nix;
  #     })
  #     .outputs;
  # };
  packages = defaultLib.genAttrs allSystems (system: (import ./pkgs {
    pkgs = nixpkgs-stable.legacyPackages.${system};
    lib = mkExtendedLib nixpkgs-stable system;
  }));
  # // mobileNixosPackages;
  formatter = defaultLib.genAttrs allSystems (system: nixpkgs-stable.legacyPackages.${system}.alejandra);
  nixosConfigurations = builtins.listToAttrs (map mkNixos nixosHosts);
  homeConfigurations = builtins.listToAttrs (map mkHome homes);
  nixOnDroidConfigurations.default = (builtins.head (map mkDroid droidHosts)).value;
in {
  inherit packages formatter nixosConfigurations homeConfigurations nixOnDroidConfigurations;
}
