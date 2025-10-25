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
        extraConfig = mkMerge ([
            "$env.config = ${builtins.toJSON (import ./config.nix)}" # NUON is a superset of JSON
            (lib.mkAfter "$env.PROMPT_INDICATOR = $'(ansi {fg: cyan_dimmed})󰬪 '")
          ]
          ++ (map (l: mkAfter l) libSourcingLines)); # Sourcing merged nu lib after integrations to use integrations within nu lib
      };
      carapace = {
        enable = true;
        enableNushellIntegration = true;
      };
      starship = {
        enable = true;
        enableNushellIntegration = true;
        settings = {
          add_newline = true;
          format = ''
            [┌─󰸵 ](bold purple)$directory$all$character
          '';
          character = {
            format = "$symbol";
            success_symbol = "[└─](bold green)";
            error_symbol = "[└─](bold red)";
          };
          continuation_prompt = "[──┤](bright-black)";
          custom = {
            unity = {
              detect_folders = ["Assets" "ProjectSettings"];
              symbol = "󰚯 Unity ";
              style = "bold white";
            };
            sudo = {
              format = "[$symbol$output]($style) ";
              symbol = " ";
              style = "bold fg:bright-red";
              when = "sudo -vn";
            };
          };
          pijul_channel.disabled = true; # slow
        };
      };
    };
    home.packages = plugins;
    custom.ephemeral.local = {
      files = ["${config.xdg.configHome}/nushell/history.txt"];
    };
  };
}
