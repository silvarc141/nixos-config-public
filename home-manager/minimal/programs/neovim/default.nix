{
  config,
  inputs,
  lib,
  customUtils,
  ...
}: {
  imports = [inputs.nixvim.homeManagerModules.nixvim] ++ customUtils.getImportable ./.;

  options.custom.nixvim = {
    # using programs.nixvim.enable causes recursion
    enable = lib.mkEnableOption "neovim configuration through nixvim";
    finalPackage = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      description = "Final, wrapped neovim package";
    };
  };

  config = let
    command = lib.getExe config.custom.nixvim.finalPackage;
    aliases = lib.genAttrs ["v" "vi" "vim" "nvim"] (name: command);
  in
    lib.mkIf config.custom.nixvim.enable {
      custom.nixvim.finalPackage =
        customUtils.writeNuScriptBin "nixvim-wrapper"
        # nu
        ''
          def --wrapped main [...args: string] {
            ${lib.getExe config.programs.nixvim.build.package} ...$args
          }
        '';
      home.sessionVariables.EDITOR = command;
      programs.nixvim = {
        enable = true;
        vimdiffAlias = true;
        globals = {
          mapleader = " ";
          maplocalleader = ",";
        };
        extraPlugins =
          []
          ++ lib.optionals config.services.activitywatch.enable [
            # TODO: temporary disabled because of some error on neovim startup
            # (pkgs.vimUtils.buildVimPlugin {
            #   name = "aw-watcher-vim";
            #   src = pkgs.fetchFromGitHub {
            #     owner = "ActivityWatch";
            #     repo = "aw-watcher-vim";
            #     rev = "4ba86d05a940574000c33f280fd7f6eccc284331";
            #     hash = "sha256-I7YYvQupeQxWr2HEpvba5n91+jYvJrcWZhQg+5rI908=";
            #   };
            # })
          ];
        extraConfigLuaPre =
          #lua
          ''
            -- utility to set operatorfunc for custom operators in lua
            local set_opfunc = vim.fn[vim.api.nvim_exec([[
              func s:set_opfunc(val)
                let &opfunc = a:val
              endfunc
              echon get(function('s:set_opfunc'), 'name')
            ]], true)]

            -- disable deprecation warnings
            vim.deprecate = function() end
          '';
      };
      programs.bash.shellAliases = aliases;
      programs.nushell.shellAliases = aliases;
      xdg.desktopEntries.nvim = {
        # TEMP WORKAROUND: hardcoded kitty, not working from thunar otherwise
        exec = "kitty --hold nvim %F";
        noDisplay = true;
        terminal = false;
        name = "Neovim";
        genericName = "Text Editor";
        type = "Application";
        icon = "nvim";
        mimeType = [
          "text/english"
          "text/plain"
          "text/x-makefile"
          "text/x-c++hdr"
          "text/x-c++src"
          "text/x-chdr"
          "text/x-csrc"
          "text/x-java"
          "text/x-moc"
          "text/x-pascal"
          "text/x-tcl"
          "text/x-tex"
          "application/x-shellscript"
          "text/x-c"
          "text/x-c++"
        ];
      };
      custom.ephemeral = {
        local = {
          directories = [
            ".local/state/nvim/swap"
            ".local/state/nvim/shada"
            ".local/state/nvim/undo"
          ];
          files = [
            ".viminfo"
            ".local/state/nvim/log"
            ".local/state/nvim/lsp.log"
            ".local/share/nvim/.netrwhist"
          ];
        };
      };
    };
}
