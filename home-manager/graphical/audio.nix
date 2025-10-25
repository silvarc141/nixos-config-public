{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.custom;
  maxVolumeString = builtins.toString (cfg.audio.maxVolume / 100.0);
in {
  options.custom.audio = {
    maxVolume = lib.mkOption {
      type = lib.types.int;
      default = 120;
    };
  };

  config = lib.mkIf cfg.graphical.enable {
    custom.graphical.desktopAgnostic.extraCommands = let
      wpctl = "${pkgs.wireplumber}/bin/wpctl";
    in {
      volumeUp = "${wpctl} set-volume --limit ${maxVolumeString} @DEFAULT_AUDIO_SINK@ 5%+";
      volumeDown = "${wpctl} set-volume --limit ${maxVolumeString} @DEFAULT_AUDIO_SINK@ 5%-";
      volumeMuteToggle = "${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle";
      micMuteToggle = "${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
    };

    custom.ephemeral = {
      data = {
        directories = [
          ".local/state/wireplumber" # audio volume
        ];
      };
      ignored = {
        files = [".config/pulse/cookie"];
      };
    };
  };
}
