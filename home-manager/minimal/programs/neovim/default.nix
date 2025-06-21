{
  config,
  inputs,
  lib,
  ...
}: {
  imports = [inputs.nixvim.homeManagerModules.nixvim] ++ lib.custom.getImportable ./.;

  # using programs.nixvim.enable causes recursion
  options.custom.nixvim.enable = lib.mkEnableOption "neovim configuration through nixvim";

  config = let
    nixvimWrapper =
      lib.custom.writeNuScriptBin "nixvim-wrapper"
      # nu
      ''
        def --wrapped main [...args: string] {
          ${config.programs.nixvim.build.package}/bin/nvim ...$args
        }
      '';
    wrapperPath = "${nixvimWrapper}/bin/nixvim-wrapper";
    aliases = lib.genAttrs ["v" "vi" "vim" "nvim"] (name: wrapperPath);
  in
    lib.mkIf config.custom.nixvim.enable {
      home.sessionVariables = {
        EDITOR = wrapperPath;
      };
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
