{
  lib,
  config,
  ...
}: {
  options.custom.workstation.unity.enable = lib.mkEnableOption "Unity engine game development configuration";

  config = lib.mkIf config.custom.workstation.unity.enable {
    nixpkgs.config.permittedInsecurePackages = ["openssl-1.1.1w"];
  };
}
