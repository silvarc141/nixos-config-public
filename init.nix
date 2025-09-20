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
  inherit (nixpkgs-stable.lib) genAttrs flatten;
  inherit (nixpkgs-stable.lib.strings) splitString;
  inherit (builtins) listToAttrs filter head elemAt;

  allSystems = [
    "x86_64-linux"
    "aarch64-linux"
  ];

  allOverlays = genAttrs allSystems (system: let
    stable = nixpkgs-stable.legacyPackages.${system};
    unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
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
    hostName = name;
    isMobile = system == "aarch64-linux";
    overlays = allOverlays.${system};
    customUtils = nix-utils.legacyPackages.${system};
    lib = nixpkgs.lib;
    nixpkgs =
      if isMobile
      then nixpkgs-unstable
      else nixpkgs-stable;
    modules =
      [./nixos]
      ++ (lib.optionals isMobile [
        ./nixos/mobile
        (import "${mobile-nixos}/lib/configuration.nix" {device = "oneplus-enchilada";})
      ]);
  in {
    inherit name;
    value = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs paths customUtils hostName overlays;
        arch = system;
      };
      inherit modules;
    };
  };

  mkDroid = name: let
    system = "aarch64-linux";
  in {
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

  mkHome = {
    name,
    system,
  }: {
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

  getNixosHosts = system: let
    inherit (nix-utils.legacyPackages.${system}) getEnumFromDir;
  in
    map (enum: let
      list = splitString "@" enum;
    in {
      name = elemAt list 0;
      system = elemAt list 1;
    }) (getEnumFromDir ./nixos/hosts);

  packages = genAttrs allSystems (system: let
    mkMobileImage = x: {
      name = "mobile-image-${x.name}";
      value = self.nixosConfigurations.${x.name}.config.mobile.outputs.android.android-fastboot-images;
    };
    armConfigs = filter (x: x.system == "aarch64-linux") (getNixosHosts system);
    mobileNixosImages = listToAttrs (map mkMobileImage armConfigs);
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

  nixosConfigurations = listToAttrs (flatten (map (system: map mkNixos (getNixosHosts system)) allSystems));

  homeConfigurations = genAttrs allSystems (
    system:
      listToAttrs (
        map (name: mkHome {inherit name system;})
        (let
          inherit (nix-utils.legacyPackages.${system}) getEnumFromDir;
        in
          getEnumFromDir ./home-manager/homes)
      )
  );

  nixOnDroidConfigurations = let
    inherit (nix-utils.legacyPackages."aarch64-linux") getEnumFromDir;
    list = map mkDroid (getEnumFromDir ./nix-on-droid/hosts);
    set = listToAttrs list;
    default = (head list).value;
  in
    {inherit default;} // set;
in {
  inherit packages formatter nixosConfigurations homeConfigurations nixOnDroidConfigurations;
}
