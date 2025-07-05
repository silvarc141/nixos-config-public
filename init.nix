{
  self,
  nixpkgs-unstable,
  nixpkgs-stable,
  home-manager,
  nix-on-droid,
  mobile-nixos,
  ...
} @ inputs: let
  inherit (nixpkgs-stable.lib) genAttrs unique catAttrs;

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

  allSystems = unique (catAttrs "system" hosts);

  allCustomUtils = genAttrs allSystems (system: let
    pkgs = nixpkgs-stable.legacyPackages.${system};
  in
    import ./custom-utils {inherit pkgs;});

  allOverlays = genAttrs allSystems (system: let
    stable = nixpkgs-stable.legacyPackages.${system};
    unstable = nixpkgs-unstable.legacyPackages.${system};
  in [
    (final: prev: (import ./overlays {inherit final prev stable unstable;}))
    (final: prev: (import ./pkgs {
      pkgs = final;
      customUtils = allCustomUtils.${system};
    }))
  ]);

  paths = {
    homeManagerConfig = ./home-manager;
    secrets = ./secrets;
    assets = ./assets;
  };

  mkNixos = {
    name,
    system,
  }: {
    inherit name;
    value = nixpkgs-stable.lib.nixosSystem {
      specialArgs = {
        inherit inputs paths;
        overlays = allOverlays.${system};
        customUtils = allCustomUtils.${system};
        hostName = name;
      };
      modules = [./nixos];
    };
  };

  mkDroid = {
    name,
    system,
  }: {
    inherit name;
    value = nix-on-droid.lib.nixOnDroidConfiguration {
      pkgs = nixpkgs-stable.legacyPackages.${system};
      extraSpecialArgs = {
        inherit inputs paths;
        overlays = allOverlays.${system};
        customUtils = allCustomUtils.${system};
        hostName = name;
      };
      modules = [./nix-on-droid];
      home-manager-path = home-manager.outPath;
    };
  };

  mkHome = name: let
    system = "x86_64-linux";
  in {
    inherit name;
    value = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs-stable.legacyPackages.${system};
      extraSpecialArgs = {
        inherit inputs paths;
        overlays = allOverlays.${system};
        customUtils = allCustomUtils.${system};
        homeType = name;
      };
      modules = [./home-manager];
    };
  };

  mobileNixosConfigurations = {
    oneplus-enchilada = nixpkgs-stable.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        (import "${mobile-nixos}/lib/configuration.nix" {device = "oneplus-enchilada";})
        ./nixos/mobile
      ];
      specialArgs = {inherit inputs;};
    };
  };
  packages = genAttrs allSystems (system: let
    mobileNixosPackages =
      if (system == "aarch64-linux")
      then {mobile-nixos-images = self.nixosConfigurations.oneplus-enchilada.config.mobile.outputs.android.android-fastboot-images;}
      else {};
  in
    (import ./pkgs {
      pkgs = nixpkgs-stable.legacyPackages.${system};
      customUtils = allCustomUtils.${system};
    })
    // mobileNixosPackages);
  formatter = genAttrs allSystems (system: nixpkgs-stable.legacyPackages.${system}.alejandra);
  nixosConfigurations = (builtins.listToAttrs (map mkNixos nixosHosts)) // mobileNixosConfigurations;
  homeConfigurations = builtins.listToAttrs (map mkHome homes);
  nixOnDroidConfigurations = let
    list = map mkDroid droidHosts;
    set = builtins.listToAttrs list;
    default = (builtins.head list).value;
  in
    {inherit default;} // set;
in {
  inherit packages formatter nixosConfigurations homeConfigurations nixOnDroidConfigurations;
}
