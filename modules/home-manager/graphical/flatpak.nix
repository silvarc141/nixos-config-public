{
  lib,
  nixosConfig,
  inputs,
  ...
}: let
  cap = nixosConfig.capabilities;
in
  with lib; {
    imports = [inputs.nix-flatpak.homeManagerModules.nix-flatpak];

    services.flatpak.packages = [
    ];

    home.persistence."${cap.optInPersistence.paths.home}/${cap.singleUser.name}" = mkIf cap.optInPersistence.enable {
      directories = [
        ".local/share/flatpak"
      ];
    };
  }
