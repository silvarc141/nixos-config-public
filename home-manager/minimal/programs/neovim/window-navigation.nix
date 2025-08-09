{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.custom.nixvim.enable {
    programs.nixvim = {
      opts = {
        scrolloff = 10;
        splitbelow = true;
        splitright = true;
      };
      autoCmd = [
        {
          # resize panes when window is resized
          event = ["VimResized"];
          command = "wincmd =";
        }
      ];
      keymaps = [
        # unmap space, which will be used as leader
        {
          mode = [""];
          key = "<Space>";
          action = "<Nop>";
        }
        # always close on <c-c>
        {
          mode = ["" "!"];
          key = "<C-c>";
          action =
            config.lib.nixvim.mkRaw
            #lua
            ''
              function()
                if #vim.api.nvim_list_wins() == 1 then
                  vim.cmd('enew')
                else
                  vim.cmd('close')
                end
              end
            '';
        }
        # tab navigation
        {
          mode = [""];
          key = "<C-t>";
          action = config.lib.nixvim.mkRaw "function() vim.cmd('tabnext') end";
        }
        {
          mode = [""];
          key = "<C-y>";
          action = config.lib.nixvim.mkRaw "function() vim.cmd('tabprevious') end";
        }
        # directional window navigation
        {
          mode = [""];
          key = "<C-h>";
          action = "<C-w>h";
        }
        {
          mode = [""];
          key = "<C-j>";
          action = "<C-w>j";
        }
        {
          mode = [""];
          key = "<C-k>";
          action = "<C-w>k";
        }
        {
          mode = [""];
          key = "<C-l>";
          action = "<C-w>l";
        }
        # <C-w> replacement
        {
          mode = [""];
          key = "<Bslash>";
          action = "<C-w>";
        }
        {
          mode = ["n"];
          key = "<C-W>d";
          action = "<Nop>";
        }
        {
          mode = ["n"];
          key = "<C-W><C-D>";
          action = "<Nop>";
        }
      ];
      plugins = {
        which-key.settings.triggers = [
          {
            __unkeyed-1 = "<Bslash>";
            mode = "nvo";
          }
        ];
      };
    };
  };
}
