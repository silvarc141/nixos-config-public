{
  config,
  lib,
  pkgs,
  ...
}: {
  options.custom.presets.minimal = {
    shell.enable = lib.mkEnableOption "basic shell components";
    dev.enable = lib.mkEnableOption "basic development components";
  };

  config = let
    inherit (lib) mkDefault;
    presets = {
      shell = {
        custom = {
          nixvim.enable = mkDefault true;
        };
        programs = {
          nushell.enable = mkDefault true;
          bat.enable = mkDefault true;
          ripgrep.enable = mkDefault true;
          btop.enable = mkDefault true;
          fastfetch.enable = mkDefault true;
          bash.enable = mkDefault true;
          zoxide.enable = mkDefault true;
          less.enable = mkDefault true;
        };
      };
      dev = {
        custom = {
          home.enable = mkDefault true;
          virtualization.enable = mkDefault true;
          notes.enable = mkDefault true;
        };
        programs = {
          git.enable = mkDefault true;
          ssh.enable = mkDefault true;
          pandoc.enable = mkDefault true;
          android-tools.enable = mkDefault true;
          direnv.enable = mkDefault true;
          aider.enable = mkDefault true;
        };
        services = {
          activitywatch.enable = mkDefault true;
          sync-nixos-config.enable = mkDefault true;
        };
        home.packages = with pkgs; [
          rustc
          cargo
        ];
      };
    };
  in
    lib.mkMerge (lib.mapAttrsToList (name: preset: lib.mkIf config.custom.presets.minimal.${name}.enable preset) presets);
}
