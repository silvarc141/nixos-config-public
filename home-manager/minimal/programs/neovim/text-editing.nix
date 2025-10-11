{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.custom.nixvim.enable {
    programs.nixvim = {
      opts = {
        ignorecase = true;
        smartcase = true;
        hlsearch = false;
        gdefault = true;

        smarttab = true;
        shiftround = true;
        expandtab = true;
        shiftwidth = 0;
        tabstop = 2;
        preserveindent = true;
        # smartindent = true; # using treesitter indentation

        undofile = true;
        undolevels = 10000;

        # no autoformatting with linebreaks, options for comments enabled
        textwidth = 0;
        formatoptions = "tcqjron/";
        # formatlistpat = TODO
      };
      plugins = {
        auto-save.enable = true; # TODO: examine if autowriteall and simple au isn't enough
        mini = {
          enable = true;
          modules = {
            surround = {
              custom_surroundings = {
                a = {
                  input = ["%'%'().*()%'%'"];
                  output = {
                    left = "''";
                    right = "''";
                  };
                };
              };
            };
            comment = {};
          };
        };
        spider.enable = true;
        sleuth.enable = true;
      };
      extraPlugins = with pkgs.vimPlugins; [
        nvim-various-textobjs
      ];
      keymaps = [
        # subword motions
        {
          key = "<C-w>";
          mode = ["n" "o" "x"];
          action = config.lib.nixvim.mkRaw ''function() require("spider").motion("w") end'';
          options = {nowait = true;};
        }
        {
          key = "<C-e>";
          mode = ["n" "o" "x"];
          action = config.lib.nixvim.mkRaw ''function() require("spider").motion("e") end'';
          options = {nowait = true;};
        }
        {
          key = "<C-b>";
          mode = ["n" "o" "x"];
          action = config.lib.nixvim.mkRaw ''function() require("spider").motion("b") end'';
        }
        # subword textobjs
        {
          mode = ["o" "x"];
          key = "a<C-w>";
          action = ''<cmd>lua require("various-textobjs").subword("outer")<CR>'';
        }
        {
          mode = ["o" "x"];
          key = "i<C-w>";
          action = ''<cmd>lua require("various-textobjs").subword("inner")<CR>'';
        }
      ];
      # no actions, using default bindings
      custom.actionPickerLayers = {
        Surround = {
          leader = "s";
          icon = "{}";
          actions = {};
        };
        FreeRealEstate = {
          leader = "x";
          icon = "{}";
          actions = {};
        };
      };
    };
  };
}
