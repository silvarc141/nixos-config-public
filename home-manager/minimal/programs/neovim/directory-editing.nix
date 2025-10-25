{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.custom.nixvim.enable {
    programs.nixvim = {
      plugins.mini = {
        enable = true;
        modules.files = {
          mappings = {
            go_in = "L";
            go_out = "H";
            go_in_plus = "l";
            go_out_plus = "h";
            close = "";
            synchronize = "";
          };
          options = {
            permanent_delete = true;
            use_as_default_explorer = true;
          };
        };
      };
      keymaps = [
        {
          mode = ["n"];
          key = "-";
          action = config.lib.nixvim.mkRaw ''
            function()
              MiniFiles.synchronize()
              if not MiniFiles.close() then
                MiniFiles.open(vim.api.nvim_buf_get_name(0), true)
                MiniFiles.reveal_cwd()
              end
            end
          '';
        }
        {
          mode = ["n"];
          key = "_";
          action = config.lib.nixvim.mkRaw ''
            function()
              MiniFiles.synchronize()
              if not (MiniFiles.close()) then MiniFiles.open() end
            end
          '';
        }
      ];
      # make mini.files-only keymaps
      autoCmd = let
        miniFilesKeymaps = [
          {
            mode = ["n"];
            key = "<CR>";
            action = "MiniFiles.synchronize()";
          }
          # find a better implementation
          {
            mode = ["n"];
            key = "<C-v>";
            action = ''
              MiniFiles.go_in( { close_on_file = true } )
              vim.cmd("wincmd v | wincmd w")
              local key = vim.api.nvim_replace_termcodes("<C-o>", true, false, true)
              vim.api.nvim_feedkeys(key, 'n', false)
            '';
          }
          {
            mode = ["n"];
            key = "<C-s>";
            action = ''
              MiniFiles.go_in( { close_on_file = true } )
              vim.cmd("wincmd s | wincmd w")
              local key = vim.api.nvim_replace_termcodes("<C-o>", true, false, true)
              vim.api.nvim_feedkeys(key, 'n', false)
            '';
          }
        ];
      in
        lib.mkIf ((builtins.length miniFilesKeymaps) > 0) [
          {
            event = "User";
            pattern = "MiniFilesBufferCreate";
            callback = let
              mkKeymap = {
                mode,
                key,
                action,
              }: ''
                vim.keymap.set({${(lib.strings.concatStringsSep ", " (map (x: "'${x}'") mode))}}, '${key}', function()
                ${action}
                end, { buffer = buf_id })
              '';
            in
              config.lib.nixvim.mkRaw ''
                function(args)
                  local buf_id = args.data.buf_id
                  ${lib.concatMapStrings mkKeymap miniFilesKeymaps}
                end
              '';
          }
        ];
    };
  };
}
