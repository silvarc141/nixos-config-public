{
  lib,
  config,
  pkgs,
  customUtils,
  ...
}: let
  libSourcingLines = map (file: "source ${file}") ([./lib.nu] ++ config.programs.nushell.extraNuLibPaths);
in {
  options.programs.nushell = {
    extraNuLibPaths = lib.mkOption {
      type = let inherit (lib.types) listOf path; in listOf path;
      default = [];
    };
    lib = lib.mkOption {
      type = let inherit (lib.types) attrsOf unspecified; in attrsOf unspecified;
      readOnly = true;
      internal = true;
      description = "nushell helpers";
    };
  };
  config = lib.mkIf config.programs.nushell.enable {
    programs = {
      nushell = {
        lib = let
          sourceNulibs = lib.concatLines libSourcingLines;
        in {
          mkNuScriptlet = text:
            lib.getExe (customUtils.writeNuScriptBin "nu-scriptlet" ''
              ${sourceNulibs}
              ${text}
            '');
          writeNuScriptBinWithLib = name: text:
            pkgs.writeNuScriptBin name ''
              ${sourceNulibs}
              ${text}
            '';
        };
        shellAliases = {
          l = "ls";
          la = "ls -a";
          ll = "ls -l";
          "+" = "nix-shell --command nu -p";
          nr = "nixos-rebuild";
          snr = "sudo nixos-rebuild";
          snrs = "sudo nixos-rebuild switch";
          snrb = "sudo nixos-rebuild boot";
          a = "act-on-path";
        };
        extraConfig = lib.mkMerge ([
            # NUON is a superset of JSON
            "$env.config = ${builtins.toJSON (import ./config.nix)}"
            # Override back PROMPT_INDICATOR, as it's needed for proper prompt change based on the current reedline menu.
            # Without an active menu, it's just appended at the end.
            # Not tested with transient or right prompt.
            (lib.mkAfter "$env.PROMPT_INDICATOR = $'(ansi {fg: cyan_dimmed})󰬪 '")
          ]
          ++ (map (l: lib.mkAfter l) libSourcingLines)); # Sourcing merged nu lib after integrations to use integrations within nu lib
        plugins = with pkgs.nushellPlugins; [formats];
      };
      carapace = {
        enable = true;
        enableNushellIntegration = true;
      };
      # FIX: causes issue with direnv + shell.nix
      # nix-your-shell = {
      #   enable = true;
      #   enableNushellIntegration = true;
      # };
      starship = {
        enable = true;
        enableNushellIntegration = true;
        settings = {
          add_newline = true;
          format = ''
            [┌─󰸵 ](bold purple)$directory$battery$all$character
          '';
          character = {
            format = "$symbol";
            success_symbol = "[└─](bold green)";
            error_symbol = "[└─](bold red)";
          };
          continuation_prompt = "[─┤](bright-black)";
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
        };
      };
    };
    custom.ephemeral.local = {
      files = [".config/nushell/history.txt"];
    };
  };
}
