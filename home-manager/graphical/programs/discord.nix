{
  lib,
  config,
  pkgs,
  ...
}: {
  options.programs.discord.enable = lib.mkEnableOption "enable Discord communication platform";

  config = lib.mkIf config.programs.discord.enable {
    home.packages = with pkgs; [discord];
    custom.ephemeral = {
      data.directories = [
        ".config/discord"
      ];
      cache.directories = [
        ".pki/nssdb" # chromium's Network Security Services location
      ];
    };
  };
}
