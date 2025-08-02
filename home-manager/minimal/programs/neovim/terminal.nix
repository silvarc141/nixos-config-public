{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.custom.nixvim.enable {
    programs.nixvim = {
      keymaps = [
        {
          mode = ["t"];
          key = "<C-]>";
          action = config.lib.nixvim.mkRaw "function() vim.cmd('stopinsert') end";
        }
      ];
      autoCmd = [
        # no folds in toggleterm window
        {
          event = ["FileType"];
          pattern = "toggleterm";
          callback = config.lib.nixvim.mkRaw ''
            function(event)
              local bufnr = event.buf
              vim.api.nvim_buf_set_option(bufnr, "foldmethod", "manual")
              vim.api.nvim_buf_set_option(bufnr, "foldtext", "foldtext()")
            end
          '';
        }
      ];
      plugins = {
        toggleterm = {
          enable = true;
          settings = {
            direction = "float";
            float_opts = {
              border = "curved";
              width = config.lib.nixvim.mkRaw "function(term) return math.floor(vim.o.columns * 0.8) end";
              height = config.lib.nixvim.mkRaw "function(term) return math.floor(vim.o.lines * 0.8) end";
              # by default, default winblend is not the default
              winblend = config.lib.nixvim.mkRaw "vim.o.winblend";
            };
            open_mapping = "[[<C-Space>]]";
            autochdir = true;
            shade_terminals = false;
            persist_mode = false;
            persist_size = false;
            highlights = {
              FloatBorder.link = "FloatBorder";
            };
          };
        };
      };
    };
  };
}
