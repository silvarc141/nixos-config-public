{nixosConfig, pkgs, lib, ...}: let cap = nixosConfig.capabilities; in {
  home.packages = [ pkgs.plastic-scm ];

  home.persistence."${cap.optInPersistence.paths.home}/${cap.singleUser.name}" = lib.mkIf cap.optInPersistence.enable {
    directories = [
      ".plastic4"
    ];
  };
}
