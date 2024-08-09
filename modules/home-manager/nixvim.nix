{
  nixosConfig,
  inputs,
  pkgs,
  lib,
  ...
}: let
  cap = nixosConfig.capabilities;
in {
  imports = [inputs.nixvim.homeManagerModules.nixvim];

  home.persistence."${cap.optInPersistence.paths.home}/${cap.singleUser.name}" = lib.mkIf cap.optInPersistence.enable {
    directories = [
      ".local/state/nvim/swap"
    ];
    files = [
      ".local/state/nvim/log"
      ".local/share/nvim/telescope_history"
    ];
  };

  programs.nixvim = {
    enable = true;
    viAlias = true;
    defaultEditor = true;
    colorschemes.cyberdream.enable = true;
    clipboard = {
      register = "unnamedplus";
      providers.wl-copy.enable = cap.graphical.hyprland.enable;
    };
    globals.mapleader = " ";
    opts = {
      number = true;
      relativenumber = true;
      numberwidth = 2;
      gdefault = true;
      smartcase = true;
      shiftwidth = 2;
      smarttab = true;
      expandtab = true;
      joinspaces = true;
      preserveindent = true;
      signcolumn = "number";
      conceallevel = 2;
    };
    keymaps = [
      {
        mode = ["t"];
        key = "<Esc>";
        action = ''<C-\><C-n>'';
      }
    ];
    plugins = {
      oil.enable = true;
      telescope = {
        enable = true;
        keymaps = {
          "<C-t>" = "fd";
        };
      };
      leap.enable = true;
      lualine.enable = true;
      which-key.enable = true;
      zk.enable = true;
      #spider.enable = true;
      #twilight.enable = true;
      #undotree.enable = true;
      #noice.enable = true;
      obsidian = {
        enable = true;
        settings = {
          workspaces = [
            {
              name = "notes";
              path = "~/notes";
            }
          ];
        };
      };
      floaterm = {
        enable = true;
        keymaps.toggle = "<C-p>";
      };
      treesitter = {
        enable = true;
      };
      treesitter-context = {
        enable = true;
      };
      /*
      treesitter-textobjects = {
        enable = true;
      };
      treesitter-refactor = {
        enable = true;
      };
      */
      lsp = {
        enable = true;
        servers = {
          nil-ls.enable = true;
          lua-ls = {
            enable = true;
            settings.telemetry.enable = false;
          };
          jsonls.enable = true;
          yamlls.enable = true;
          taplo.enable = true;
          bashls.enable = true;
          #gdscript.enable = true;
          #pylsp.enable = true;
          #typos-lsp.enable = true;
          /*
          omnisharp = {
            enable = true;
            cmd = [
              "${pkgs.omnisharp-roslyn}/bin/OmniSharp"
              "--languageserver"
              "--hostPID $(pgrep nvim | head -n 1)"
              #"mono"
            ];
            settings = {
              enableEditorConfigSupport = false;
              enableMsBuildLoadProjectsOnDemand = false;
              enableRoslynAnalyzers = false;
              organizeImportsOnFormat = false;
              enableImportCompletion = false;
              sdkIncludePrereleases = true;
              analyzeOpenDocumentsOnly = false;
            };
          };
          */
        };
        keymaps.lspBuf = {
          "gd" = "definition";
          "gD" = "references";
          "gt" = "type_definition";
          "gi" = "implementation";
          "K" = "hover";
        };
      };
      #lsp-format.enable = true;
      #nvim-lightbulb.enable = true;
      #codeium-nvim.enable = true;
      cmp = {
        enable = true;
        settings = {
          sources = [
            {name = "nvim_lsp";}
            {name = "path";}
            {name = "buffer";}
            # {name = "codeium";}
          ];
        };
      };
    };
    extraPlugins = [
      pkgs.vimPlugins.omnisharp-extended-lsp-nvim
      pkgs.vimPlugins.zoxide-vim
      (pkgs.vimUtils.buildVimPlugin {
        name = "";
        src = pkgs.fetchFromGitHub {
          owner = "fei6409";
          repo = "log-highlight.nvim";
          rev = "2867afe132b1c94c454f95758409da320ab4b084";
          hash = "sha256-3COW6+YPCGkBLbiQl1O4Z2aIaH0stGjxrqtjr/UIx9w=";
        };
      })
    ];
    extraConfigLua = ''
      if vim.g.neovide then
        vim.g.neovide_cursor_animation_length = 0.03
        vim.g.neovide_cursor_vfx_mode = "pixiedust"
      end

      local pid = vim.fn.getpid()
      require'lspconfig'.omnisharp.setup{
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
      }
    '';
  };
}
