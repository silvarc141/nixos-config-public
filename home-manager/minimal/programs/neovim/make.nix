{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.custom.nixvim.enable {
    programs.nixvim = {
      custom.actionPickerLayers = {
        Build = {
          leader = "<leader>b";
          icon = "B";
          isLua = true;
          actions = {
            b = {
              description = "Build";
              action = "async_make()";
            };
          };
        };
      };
      userCommands = {
        Make = {
          command = "lua async_make()";
          bang = true;
        };
      };
      extraConfigLuaPre =
        #lua
        ''
          function async_make()
            local lines = {""}
            local winnr = vim.fn.win_getid()
            local bufnr = vim.api.nvim_win_get_buf(winnr)

            local makeprg = vim.api.nvim_buf_get_option(bufnr, "makeprg")
            if not makeprg then return end

            local cmd = vim.fn.expandcmd(makeprg)

            local function on_event(job_id, data, event)
              if event == "stdout" or event == "stderr" then
                if data then
                  vim.list_extend(lines, data)
                end
              end

              if event == "exit" then
                vim.fn.setqflist({}, " ", {
                  title = cmd,
                  lines = lines,
                  efm = vim.api.nvim_buf_get_option(bufnr, "errorformat")
                })
                vim.api.nvim_command("doautocmd QuickFixCmdPost")
              end
            end

            local job_id =
              vim.fn.jobstart(
              cmd,
              {
                on_stderr = on_event,
                on_stdout = on_event,
                on_exit = on_event,
                stdout_buffered = true,
                stderr_buffered = true,
              }
            )
          end
        '';
    };
  };
}
