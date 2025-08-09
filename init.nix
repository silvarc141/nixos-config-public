{
  self,
  nixpkgs-unstable,
  nixpkgs-stable,
  home-manager,
  nix-on-droid,
  mobile-nixos,
  nix-utils,
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
    {
      name = "ope";
      system = "aarch64-linux";
    }
    {
      name = "opx";
      system = "aarch64-linux";
    }
    {
      name = "sg3";
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
    "workstation-travel"
    "workstation-test"
    "server"
    "wsl"
    "droid"
  ];

  hosts = nixosHosts ++ droidHosts ++ darwinHosts;

  allSystems = unique (catAttrs "system" hosts);

  allOverlays = genAttrs allSystems (system: let
    stable = nixpkgs-stable.legacyPackages.${system};
    unstable = nixpkgs-unstable.legacyPackages.${system};
  in [
    (final: prev: (import ./overlays {inherit inputs final prev stable unstable;}))
    (final: prev: (import ./pkgs {
      pkgs = final;
      customUtils = nix-utils.legacyPackages.${system};
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
  }: let
    isMobile = system == "aarch64-linux";
    nixpkgs =
      if isMobile
      then nixpkgs-unstable
      else nixpkgs-stable;
    # modules = [./nixos] ++ (optionals isMobile [
    #     ./nixos/mobile
    #     (import "${mobile-nixos}/lib/configuration.nix" { device = "oneplus-enchilada"; })
    #   ]);
    modules =
      if isMobile
      then [
        (import "${mobile-nixos}/lib/configuration.nix" {device = "oneplus-enchilada";})
        ./mobile-minimal-graphical.nix
      ]
      else [./nixos];
  in {
    inherit name;
    value = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs paths;
        overlays = allOverlays.${system};
        customUtils = nix-utils.legacyPackages.${system};
        hostName = name;
      };
      inherit modules;
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
        customUtils = nix-utils.legacyPackages.${system};
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
        customUtils = nix-utils.legacyPackages.${system};
        homeType = name;
        isNixosModule = false;
      };
      modules = [./home-manager];
    };
  };

  packages = genAttrs allSystems (system: let
    mkMobileImage = x: {
      name = "mobile-image-${x.name}";
      value = self.nixosConfigurations.${x.name}.config.mobile.outputs.android.android-fastboot-images;
    };
    armConfigs = builtins.filter (x: x.system == "aarch64-linux") nixosHosts;
    mobileNixosImages = builtins.listToAttrs (map mkMobileImage armConfigs);
    mobileNixosPackages =
      if (system == "aarch64-linux")
      then mobileNixosImages
      else {};

    packaged = import ./pkgs {
      pkgs = nixpkgs-stable.legacyPackages.${system};
      customUtils = nix-utils.legacyPackages.${system};
    };
  in
    packaged // mobileNixosPackages);

  formatter = genAttrs allSystems (system: nixpkgs-stable.legacyPackages.${system}.alejandra);
  nixosConfigurations = builtins.listToAttrs (map mkNixos nixosHosts);
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
