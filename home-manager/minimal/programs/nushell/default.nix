{
  lib,
  config,
  pkgs,
  customUtils,
  ...
}: let
  inherit (lib) mkOption types mkIf concatLines getExe mkMerge mkAfter;
  inherit (lib.hm.nushell) mkNushellInline;
  libSourcingLines = map (file: "source ${file}") ([./lib.nu] ++ config.programs.nushell.extraNuLibPaths);
  plugins = with pkgs.nushellPlugins; [formats];
in {
  options.programs.nushell = {
    extraNuLibPaths = mkOption {
      type = let inherit (types) listOf path; in listOf path;
      default = [];
    };
    lib = mkOption {
      type = let inherit (types) attrsOf unspecified; in attrsOf unspecified;
      readOnly = true;
      internal = true;
      description = "nushell helpers";
    };
  };
  config = mkIf config.programs.nushell.enable {
    programs = {
      nushell = {
        inherit plugins;
        lib = let
          sourceNulibs = concatLines libSourcingLines;
          inherit (customUtils) writeNuScriptBin;
        in {
          inherit writeNuScriptBin;
          writeNuScriptBinLib = name: text:
            writeNuScriptBin name ''
              ${sourceNulibs}
              ${text}
            '';
          writeNuSnippet = text: getExe (customUtils.writeNuScriptBin "nu-snippet" text);
        };
        shellAliases = {
          x = "__xdg-open-detached";
          fg = "job unfreeze";
          l = "ls";
          la = "ls -a";
          ll = "ls -l";
          lla = "ls -la";
          lal = "ls -la";
          nrb = "nixos-rebuild build";
          snrs = "sudo nixos-rebuild switch";
          snrb = "sudo nixos-rebuild boot";
          "+" = "__nix-shell-nixpkgs";
          ">" = "__nix-run-nixpkgs";
          nse = "nix-symlink extract";
          nsr = "nix-symlink restore";
        };
        environmentVariables = {
          PROMPT_INDICATOR = mkNushellInline "$'(ansi {fg: red_dimmed})• '";
          PROMPT_COMMAND = mkNushellInline ''{|| $"(ansi {fg: cyan_dimmed})┌──(pwd)\n└─"}'';
          TRANSIENT_PROMPT_COMMAND = mkNushellInline "$'(ansi {fg: red_dimmed})$ '";
          PROMPT_COMMAND_RIGHT = "";
          TRANSIENT_PROMPT_INDICATOR = "";
        };
        extraConfig =
          mkMerge (["$env.config = ${builtins.toJSON (import ./config.nix)}"] # NUON is a superset of JSON
            ++ (map (l: mkAfter l) libSourcingLines)); # Sourcing merged nu lib after integrations to use integrations within nu lib
      };
      carapace = {
        enable = true;
        enableNushellIntegration = true;
      };
      starship.enableNushellIntegration = false;
      # WARNING: can cause issues with direnv + shell.nix
      nix-your-shell = {
        enable = true;
        enableNushellIntegration = true;
      };
    };
    home.packages = plugins;
    custom.ephemeral.local = {
      files = ["${config.xdg.configHome}/nushell/history.txt"];
    };
  };
}
