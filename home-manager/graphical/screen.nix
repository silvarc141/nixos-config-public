{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.custom;
in {
  options.custom.screen = {
    initialBrightness = lib.mkOption {
      type = lib.types.int;
      default = 50;
    };
  };
  config = lib.mkIf config.custom.graphical.enable {
    custom.graphical.desktopAgnostic.extraCommands = let
      bctl = lib.getExe pkgs.brightnessctl;
      grim = lib.getExe pkgs.grim;
      slurp = lib.getExe pkgs.slurp;
      swappy = lib.getExe pkgs.swappy;
      wl-copy = "${pkgs.wl-clipboard}/bin/wl-copy";
      wl-paste = "${pkgs.wl-clipboard}/bin/wl-paste";
      date = "${pkgs.coreutils}/bin/date";
      unsortedDir = "${config.home.homeDirectory}/${config.custom.home.unsorted}";
    in {
      brightnessUp = "${bctl} -c backlight set +5%";
      brightnessDown = "${bctl} -c backlight set 5%-";
      brightnessDim = "${bctl} -s set 10%";
      brightnessUndim = "${bctl} -r";
      screenshotRegionToClipboard = "${grim} -g \"$(${slurp})\" - | ${wl-copy}";
      annotateImageFromClipboard = "${wl-paste} | ${swappy} -f -";
      saveClipboardAsPNG = lib.getExe (pkgs.writeShellScriptBin "save-clipboard-as-png" ''
        DIR=${unsortedDir}/screenshots
        FILE=$DIR/$(${date} +%Y%m%d-%H%M%S).png
        mkdir -p "$DIR"
        ${wl-paste} > "$FILE"
        echo "$FILE" | ${wl-copy}
      '');
    };
    home.packages = with pkgs; [grim slurp swappy];
    systemd.user = {
      enable = true;
      services.initial-brightness = {
        Service = {
          ExecStart = "${pkgs.brightnessctl}/bin/brightnessctl set ${builtins.toString cfg.screen.initialBrightness}%";
          Restart = "on-failure";
        };
        Install = {
          WantedBy = ["default.target"];
        };
      };
    };
  };
}
