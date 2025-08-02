{
  config,
  lib,
  ...
}: {
  options.custom.mobile.enable = lib.mkEnableOption "enable mobile configuration";

  config = lib.mkIf config.custom.mobile.enable {
    mobile.beautification = {
      silentBoot = false;
      splash = lib.mkDefault true;
    };
    nixpkgs.config.permittedInsecurePackages = ["olm-3.2.16"];
    boot.kernelModules = ["autofs4"]; # needed for boot for some reason, probably impermanence
    environment.persistence = lib.mkForce {};
  };
}
