{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.custom.nixvim.enable {
    programs.nixvim = {
      extraPlugins = with pkgs.vimPlugins; [resession-nvim];
      extraConfigLua = ''
        require("resession").setup({
          autosave = {
            enabled = true,
            interval = 30,
            notify = false,
          },
        })
      '';
      custom.actionPickerLayers = {
        Sessions = {
          leader = "<leader>s";
          icon = "";
          isLua = true;
          actions = {
            l = {
              description = "Load";
              action = "require('resession').load()";
            };
            s = {
              description = "Save";
              action = "require('resession').save()";
            };
            d = {
              description = "Delete";
              action = "require('resession').delete()";
            };
          };
        };
      };
    };
    custom.ephemeral = {
      local = {
        directories = [
          ".local/share/nvim/session"
        ];
      };
    };
  };
}
