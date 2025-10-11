# TODO: limit completors for performance
# TODO: consider snippet engine: luasnip, snippy, ultisnips, vsnip
# TODO: maybe try blink when it is more production ready
{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.custom.nixvim.enable {
    programs.nixvim = {
      opts = {
        pumheight = 10;
      };
      plugins = {
        cmp-nvim-lsp.enable = true;
        cmp-nvim-lsp-signature-help.enable = true;
        cmp-nvim-lsp-document-symbol.enable = true;
        cmp-path.enable = true;
        cmp-buffer.enable = true;
        cmp-calc.enable = true;
        cmp-cmdline.enable = true;
        cmp-cmdline-history.enable = true;
        cmp-rg.enable = true;
        cmp-dictionary.enable = true; # doesn't want to work -> inspect setup
        cmp-nvim-lua.enable = true; # monitor if useful
        # cmp-yanky.enable = true; # consider
        # cmp-git.enable = true; # consider, lots of config
        # cmp-luasnip.enable = true; # consider
        cmp = let
          mapping = {
            "<Tab>" = "cmp.mapping.confirm({select = true, behavior = cmp.ConfirmBehavior.Replace})";
            "<C-p>" = "cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select })";
            "<C-n>" = "cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select })";
            "<C-d>" = "cmp.mapping.scroll_docs(6)"; # conflict with unindent
            "<C-u>" = "cmp.mapping.scroll_docs(-6)"; # confict with delete until
          };
          preselect = "cmp.PreselectMode.Item";
          sources = [
            {name = "nvim_lsp";}
            {name = "nvim_lsp_signature_help";}
            {name = "path";}
            {name = "calc";}
            {
              name = "rg";
              keyword_length = 3;
            }
            {name = "nvim_lua";}
          ];
        in {
          enable = true;
          autoEnableSources = false;
          settings = {
            inherit mapping preselect sources;
            completion = {
              autocomplete = [
                "require('cmp.types').cmp.TriggerEvent.TextChanged"
                "require('cmp.types').cmp.TriggerEvent.InsertEnter"
              ];
              keyword_length = 1; # setting to 0 doesn't do anything
            };
            window = {
              completion = config.lib.nixvim.mkRaw "cmp.config.window.bordered()";
              documentation = config.lib.nixvim.mkRaw "cmp.config.window.bordered()";
            };
            view.entries = {
              name = "custom";
              selection_order = "near_cursor";
            };
            performance = {
              max_view_entries = config.programs.nixvim.opts.pumheight; # show only as much as instantly visible
            };
          };
          cmdline = let
            cmdMapping = lib.mapAttrs (name: value: "{ c = ${value} }") mapping;
            cmdSources = [
              {
                name = "cmdline_history";
                keyword_length = 2;
              }
            ];
            searchConfig = {
              inherit preselect;
              mapping = cmdMapping;
              sources =
                cmdSources
                ++ [
                  {name = "buffer";}
                  {name = "nvim_lsp_document_symbol";}
                ];
            };
          in {
            "/" = searchConfig;
            "?" = searchConfig;
            ":" = {
              inherit preselect;
              mapping = cmdMapping;
              sources =
                cmdSources
                ++ [
                  {name = "path";}
                  {
                    name = "cmdline";
                    keyword_length = 2;
                    option.ignore_cmds = ["Man" "!"];
                  }
                ];
            };
          };
          filetype = {
            markdown = {
              inherit mapping preselect;
              sources =
                sources
                ++ [
                  {
                    name = "dictionary";
                    keyword_length = 2;
                  }
                ];
            };
          };
        };
      };
      keymaps = [
        # allow Tab in insert mode to only handle completion select
        {
          key = "<Tab>";
          action = "<Nop>";
          mode = ["i" "c"];
        }
        # allow <C-p> and <C-n> in insert mode to only handle completion previous/next
        {
          key = "<C-p>";
          action = "<Nop>";
          mode = ["i"];
        }
        {
          key = "<C-n>";
          action = "<Nop>";
          mode = ["i"];
        }
      ];
    };
  };
}
