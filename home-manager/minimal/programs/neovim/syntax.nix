{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.custom.nixvim.enable {
    programs.nixvim = {
      plugins = {
        treesitter = {
          enable = true;
          nixvimInjections = false; # commentstring issue
          settings = {
            highlight.enable = true;
            indent = {
              enable = true;
              disable = ["yaml"];
            };
            # test if useful, since it competes against textobjects
            incremental_selection = {
              enable = true;
              keymaps = {
                init_selection = "gnn";
                node_decremental = "grm";
                node_incremental = "grn";
                scope_incremental = "grc";
              };
            };
          };
        };
        treesitter-textobjects = {
          enable = true;
          select = {
            enable = true;
            lookahead = true;
            keymaps = {
              "if" = {
                query = "@function.inner";
              };
              "af" = {
                query = "@function.outer";
              };
              "ic" = {
                query = "@class.inner";
              };
              "ac" = {
                query = "@class.outer";
              };
            };
          };
          # swap = {
          #   enable = true;
          #   swapNext = {
          #     "<a-j>" = {
          #       query = "@parameter.inner";
          #     };
          #     "<a-k>" = {
          #       query = "@parameter.inner";
          #     };
          #   };
          # };
        };
        /*
        treesitter-refactor = {
          enable = true;
        };
        */
        lsp-format.enable = true;
        lsp = {
          enable = true;
          servers = {
            nil_ls = {
              enable = true;
              settings.nix.flake.autoArchive = true;
            };
            lua_ls = {
              enable = true;
              settings.telemetry.enable = false;
            };
            jsonls.enable = true;
            yamlls.enable = true;
            taplo.enable = true;
            bashls.enable = true;
            nushell.enable = true;
            ts_ls.enable = true;
            # eslint.enable = true;
            # ruby_lsp.enable = true;
            # rubocop.enable = true;
          };
          keymaps.lspBuf = {
            "gd" = "definition";
            "gD" = "references";
            "gt" = "type_definition";
            "gi" = "implementation";
            "K" = "hover";
          };
        };
        render-markdown = {
          enable = true;
          settings = {
            pipe_table.style = "normal";
            # does not work for some reason
            code.conceal_delimiters = false;
          };
        };
      };
      extraPlugins = with pkgs.vimPlugins;
        [
          omnisharp-extended-lsp-nvim
          csvview-nvim
        ]
        ++ (with pkgs; [
          (vimUtils.buildVimPlugin {
            name = "";
            src = fetchFromGitHub {
              owner = "fei6409";
              repo = "log-highlight.nvim";
              rev = "2867afe132b1c94c454f95758409da320ab4b084";
              hash = "sha256-3COW6+YPCGkBLbiQl1O4Z2aIaH0stGjxrqtjr/UIx9w=";
            };
          })
        ]);
      autoCmd = [
        {
          command = ''
            setlocal nowrap
            CsvViewEnable
          '';
          event = [
            "BufReadPre"
            "BufNewFile"
          ];
          pattern = [
            "*.csv"
            "*.tsv"
          ];
        }
        {
          command = ''
            setlocal indentkeys -=<:>
          '';
          event = ["FileType"];
          pattern = ["yaml"];
        }
        {
          command = ''
            setlocal commentstring=#\ %s
          '';
          event = [
            "BufReadPre"
            "BufNewFile"
          ];
          pattern = [
            "*.nu"
          ];
        }
      ];
      extraConfigLua =
        #lua
        ''
          local pid = vim.fn.getpid()
          require('lspconfig').omnisharp.setup({
            on_attach = on_attach,
            flags = {
              debounce_text_changes = 150,
            },
            cmd = {
              "${pkgs.omnisharp-roslyn}/bin/OmniSharp",
              "--languageserver",
              "--hostPID",
              tostring(pid)
            }
          })

          require('csvview').setup({
            view = {
              display_mode = "border",
            },
          })
        '';
    };
  };
}
