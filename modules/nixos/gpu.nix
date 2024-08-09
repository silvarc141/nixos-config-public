{
  lib,
  config,
  ...
}:
with lib; {
  options.capabilities.gpu.enable = mkEnableOption "enable gpu configuration";

  config = mkIf config.capabilities.gpu.enable {
    services.xserver.videoDrivers = ["nvidia"];
    hardware.nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
      prime = {
        sync.enable = true;
        nvidiaBusId = "PCI:1:0:0";
        amdgpuBusId = "PCI:5:0:0";
      };
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
}
