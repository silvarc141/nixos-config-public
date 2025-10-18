{
  pkgs,
  config,
  lib,
  ...
}: {
  options.services.wivrn.enable = lib.mkEnableOption "configuration of WIVRN PCVR wireless link";

  config = lib.mkIf config.services.wivrn.enable {
    xdg.configFile."openxr/1/active_runtime.json".source = "${pkgs.wivrn}/share/openxr/1/openxr_wivrn.json";
    # set opencomposite as default runtime so that steam uses it instead of default steamvr
    # steam shouldn't overwrite it when it is readonly
    xdg.configFile."openvr/openvrpaths.vrpath".text = ''
      {
        "config" :
        [
          "${config.xdg.dataHome}/Steam/config"
        ],
        "external_drivers" : null,
        "jsonid" : "vrpathreg",
        "log" :
        [
          "${config.xdg.dataHome}/Steam/logs"
        ],
        "runtime" :
        [
          "${pkgs.opencomposite}/lib/opencomposite"
        ],
        "version" : 1
      }
    '';

    custom.ephemeral.data.directories = [".config/wivrn"];
  };
}
