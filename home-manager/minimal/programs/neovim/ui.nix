{
  lib,
  config,
  pkgs,
  ...
}: {
  config = lib.mkIf config.custom.nixvim.enable {
    programs.nixvim = {
      opts = {
        number = true;
        relativenumber = true;
        numberwidth = 2;
        signcolumn = "number";

        # hide statusline
        laststatus = 0;
        statusline = "%!luaeval(\"string.rep('─', vim.api.nvim_win_get_width(vim.g.statusline_winid))\")";

        wrap = true;
        linebreak = true;
        showbreak = "󰘍 ";
        breakat = " ^!@*-+;:,./?\"\\'";
        breakindent = true;

        termguicolors = true;
        shortmess = "aAIcCsSoOF";
        conceallevel = 2;

        # could replace noice
        # reexamine if the issue gets fixed: https://github.com/neovim/neovim/issues/24059
        # cmdheight = 0;
        # more = false;

        # list = true;
        # listchars = "tab:▏,trail:·,extends:»,precedes:«";
      };
      colorschemes.catppuccin = {
        enable = true;
        settings = {
          flavour = "mocha";
          integrations = {
            cmp = true;
            treesitter = true;
            mini = {
              enabled = true;
              indentscope_color = "surface0";
            };
          };
          term_colors = true;
        };
      };
      highlight = {
        # fake win separator to hide statusline
        StatusLine = {
          link = "Normal";
          default = true;
        };
        StatusLineNC = {
          link = "Normal";
          default = true;
        };

        # context should not look like a floating window
        TreesitterContext = {
          link = "Normal";
          default = true;
        };

        QuickScopePrimary = {
          underline = true;
          sp = "#9399b2";
        };
        QuickScopeSecondary = {
          underdouble = true;
          sp = "#9399b2";
        };
      };
      highlightOverride = {
        # fake win separator to hide statusline
        StatusLine.link = "WinSeparator";
        StatusLineNC.link = "WinSeparator";

        # context should not look like a floating window
        TreesitterContext = {
          nocombine = true;
          blend = 0;
        };
        TreesitterContextLineNumber.link = "LineNr";

        # hide context bottom line
        TreesitterContextBottom.link = "TreesitterContext";
      };
      plugins = {
        # nvim-lightbulb.enable = true; # to try
        image.enable = true;
        dressing = {
          enable = true;
          settings = {
            select = {
              enabled = true;
              backend = ["telescope"];
              telescope = config.programs.nixvim.plugins.telescope.settings.defaults;
            };
            input = {
              enabled = true;
              relative = "editor";
              prefer_width = 0.5;
            };
          };
        };
        treesitter-context = {
          enable = true;
          settings = {
            max_lines = 6;
            min_window_height = 30;
            multiline_threshold = 2;
          };
        };
        mini = {
          modules = {
            indentscope = {
              symbol = "│";
              options = {
                try_as_border = true;
              };
              draw = {
                delay = 100;
              };
            };
          };
        };
        # rainbow-delimiters.enable = true; # check if missing
        helpview.enable = true;
        which-key = {
          enable = true;
          settings = {
            icons.group = "";
            delay = 100;
            win = {
              border = "rounded";
              padding = [1 2];
              wo.winblend = config.lib.nixvim.mkRaw "vim.o.winblend";
            };
          };
        };
        web-devicons.enable = true;
        noice = {
          enable = true;
          settings = {
            presets = {
              long_message_to_split = true;
            };
            views = {
              cmdline_popup = {
                size = {
                  width = 0.5;
                  height = 1;
                };
                position = {
                  col = 0.5;
                  row = 0.5;
                };
              };
            };
            cmdline = {
              format = {
                input = {};
                cmdline = {
                  icon = "";
                  lang = "vim";
                  pattern = "^:";
                };
                search_down = {
                  icon = " ";
                  kind = "search";
                  lang = "regex";
                  pattern = "^/";
                };
                search_up = {
                  icon = " ";
                  kind = "search";
                  lang = "regex";
                  pattern = "^?";
                };
                filter = {};
                shell = {
                  icon = "";
                  lang = "nu";
                  pattern = "^:%s*!";
                };
                help = {
                  icon = "󰋖";
                  pattern = "^:%s*he?l?p?%s+";
                };
                lua = {
                  icon = "󰢱";
                  lang = "lua";
                  pattern = "^:%s*lua%s+";
                };
                selection = {
                  icon = "󰒉";
                  lang = "vim";
                  pattern = "^:%s*'<,'>%s*";
                };
                whole_file = {
                  icon = "󰁌";
                  lang = "vim";
                  pattern = "^:%s*%%%s*";
                };
                substitute_all = {
                  icon = "󰁌 󰬳"; #
                  lang = "perl";
                  pattern = "^:%s*%%%s*s%s*/";
                };
                substitute_selection = {
                  icon = "󰒉 󰬳"; #
                  lang = "perl";
                  pattern = "^:%s*'<,'>%s*s%s*/";
                };
              };
            };
            # gotta reimplement for correct window size because this unsets instead of overwriting
            # commands = {
            #   last = {
            #     opts = {
            #       size.width = 0.75;
            #     };
            #   };
            # };
          };
        };
      };
      extraPlugins = [
        pkgs.vimPlugins.quick-scope
        (pkgs.vimUtils.buildVimPlugin {
          name = "incline-nvim";
          src = pkgs.fetchFromGitHub {
            owner = "b0o";
            repo = "incline.nvim";
            rev = "16fc9c073e3ea4175b66ad94375df6d73fc114c0";
            hash = "sha256-5DoIvIdAZV7ZgmQO2XmbM3G+nNn4tAumsShoN3rDGrs=";
          };
        })
      ];
      extraConfigLua = ''
        -- image.nvim {{{
        require("image").setup({
          max_height_window_percentage = 100,
        })
        -- }}}

        -- quick-scope {{{
        vim.g.qs_buftype_blacklist = {'terminal', 'nofile', 'special', 'help', 'man'}
        vim.g.qs_highlight_on_keys = {'f', 'F', 't', 'T'}
        vim.g.qs_delay = 0;
        -- }}}

        -- incline {{{
        require('incline').setup {
          window = {
            padding = 0,
            margin = { horizontal = 0 },
          },
          highlight = {
            groups = {
              InclineNormal = {
                default = true,
                group = "LineNr"
              },
              InclineNormalNC = {
                default = true,
                group = "LineNr"
              }
            }
          },
          render = function(props)
            local helpers = require 'incline.helpers'
            local devicons = require 'nvim-web-devicons'

            function blend(color1_hex, color2_hex, blend_amount)
              local color1_rgb = helpers.hex_to_rgb(color1_hex)
              local color2_rgb = helpers.hex_to_rgb(color2_hex)
              local color_blend_rgb = {}
              for k,v in pairs(color1_rgb) do
                color_blend_rgb[k] = color2_rgb[k] * blend_amount + color1_rgb[k] * (1 - blend_amount)
              end
              return helpers.rgb_to_hex(color_blend_rgb);
            end

            local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
            if filename == "" then
              filename = "[no name]"
            end

            local fg_color = string.format("#%06x",vim.api.nvim_get_hl(0, { name = "LineNr" }).fg)
            local filetype_icon, filetype_color = devicons.get_icon_color(filename)

            if filetype_color then
              filetype_color = blend(fg_color, filetype_color, 0.4)
            else
              filetype_color = fg_color
            end

            local modified = vim.bo[props.buf].modified
            return {
              { modified and " " or "" },
              filetype_icon and { " ", filetype_icon, " ", guifg = filetype_color or ""},
              " ",
              { filename, guifg = text_color },
            }
          end,
        }
        -- }}}
      '';
      extraConfigLuaPre = ''
        -- neovide {{{
        if vim.g.neovide then
          vim.o.guifont = "JetBrainsMono Nerd Font:9"
          vim.o.winblend = 20

          vim.g.neovide_floating_blur_amount_x = 8.0
          vim.g.neovide_floating_blur_amount_y = 8.0

          vim.g.neovide_scroll_animation_length = 0.1

          vim.g.neovide_cursor_trail_size = 0.5
          vim.g.neovide_cursor_animation_length = 0.03
          vim.g.neovide_cursor_animate_command_line = false

          vim.g.neovide_padding_top = 0
          vim.g.neovide_padding_bottom = 0
          vim.g.neovide_padding_right = 0
          vim.g.neovide_padding_left = 0

          -- figure out how to make it ignore treesitter context window, then reenable
          vim.g.neovide_floating_shadow = false
        end
        -- }}}
      '';
    };
    custom.ephemeral.local.files = [".local/state/nvim/noice.log"];
  };
}
