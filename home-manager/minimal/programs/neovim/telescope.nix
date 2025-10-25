{
  config,
  lib,
  ...
}: let
  mkRaw = config.lib.nixvim.mkRaw;
in {
  config = lib.mkIf config.custom.nixvim.enable {
    programs.nixvim = {
      plugins = {
        telescope = {
          enable = true;
          settings = {
            defaults = {
              sorting_strategy = "ascending";
              layout_strategy = "flex";
              layout_config = {
                anchor = "CENTER";
                height = mkRaw "function(self, max_columns, max_lines) return math.floor(vim.o.lines * 0.82) end";
                width = mkRaw "function(self, max_columns, max_lines) return math.floor(vim.o.columns * 0.82) end";
                prompt_position = "top";
                preview_cutoff = 25;
                flex = {
                  flip_columns = 120;
                };
                vertical = {
                  mirror = true;
                };
              };
              mappings = {
                i = {
                  "<C-s>" = mkRaw "require('telescope.actions').file_split";
                };
                n = {
                  "<C-s>" = mkRaw "require('telescope.actions').file_split";
                  "<C-c>" = mkRaw "require('telescope.actions').close";
                };
              };
            };
          };
          extensions = {
            undo.enable = true;
            frecency.enable = true;
            manix.enable = true;
            /*
            zoxide.settings = {
              prompt_title = "ZZZ";
              mappings = {
                default = {
                  after_action = mkRaw ''function(selection) print("Update to (" .. selection.z_score .. ") " .. selection.path) end'';
                };
                "<C-s>" = {
                  before_action = mkRaw ''function(selection) print("before C-s") end'';
                  action = mkRaw ''function(selection) vim.cmd.edit(selection.path) end'';
                };
                "<C-q>" = {action = mkRaw ''z_utils.create_basic_command("split")'';};
              };
            };
            */
          };
          # enabledExtensions = ["zoxide"];
        };
      };
      # extraPlugins = with pkgs.vimPlugins; [zoxide-vim telescope-zoxide];
      custom.actionPickerLayers = {
        Find = {
          leader = "<leader>f";
          icon = "󰛔";
          isLua = true;
          actions = {
            f = {
              description = "Recent files";
              action = "require('telescope').extensions.frecency.frecency()";
            };
            g = {
              description = "Grep";
              action = "require('telescope.builtin').live_grep()";
            };
            d = {
              description = "Directory files";
              action = "require('telescope.builtin').find_files()";
            };
            t = {
              description = "Treesitter";
              action = "require('telescope.builtin').treesitter()";
            };
            h = {
              description = "Highlights";
              action = "require('telescope.builtin').highlights()";
            };
            u = {
              description = "Undo";
              action = "require('telescope').extensions.undo.undo()";
            };
            r = {
              description = "Resume";
              action = "require('telescope.builtin').resume()";
            };
          };
        };
      };
    };
    custom.ephemeral = {
      local = {
        files = [
          ".local/share/nvim/telescope_history"
          ".local/state/nvim/file_frecency.bin"
        ];
      };
    };
  };
}
