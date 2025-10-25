{
  config,
  lib,
  ...
}: {
  config = lib.mkIf (config.custom.nixvim.enable && config.custom.notes.enable) {
    programs.nixvim = {
      autoCmd = [
        # reenable this if needed
        # {
        #   # enter daily note when opening without buffers
        #   event = ["VimEnter"];
        #   callback = config.lib.nixvim.mkRaw ''
        #     function()
        #       if vim.fn.argc() == 0 and vim.fn.line2byte('$') == -1 then
        #         local client = require("obsidian").get_client()
        #         client:open_note(client:today())
        #         vim.cmd("set nobl")
        #       end
        #     end
        #   '';
        # }
      ];
      plugins = {
        markdown-preview.enable = true;
        obsidian = {
          enable = true;
          settings = {
            follow_img_func =
              #lua
              ''
                function(img)
                  vim.fn.jobstart({"xdg-open", img})
                end
              '';
            follow_url_func =
              #lua
              ''
                function(url)
                  vim.fn.jobstart({"xdg-open", url})
                end
              '';
            note_id_func =
              #lua
              ''
                function(title)
                  math.randomseed(os.time())
                  local suffix = ""
                  for _ = 1, 4 do
                    suffix = suffix .. string.char(math.random(65, 90))
                  end
                  return tostring(os.date("%Y-%m-%d-%H-%M-%S")) .. "-" .. suffix
                end
              '';
            notes_subdir = "named";
            new_notes_location = "notes_subdir";
            templates = {
              subdir = "templates";
            };
            daily_notes = {
              folder = "daily";
              template = "daily.md";
            };
            workspaces = [
              {
                name = "notes";
                path = "/home/silvarc/${config.custom.notes.location}";
              }
            ];
            attachments = {
              confirm_img_paste = false;
              img_folder = "assets";
            };
            mappings = {
              gf = {
                action = "require('obsidian').util.gf_passthrough";
                opts = {
                  buffer = true;
                  expr = true;
                  noremap = false;
                };
              };
              "<CR>" = {
                action = "require('obsidian').util.smart_action";
                opts = {
                  buffer = true;
                  expr = true;
                };
              };
            };
            # disable while using render-markdown.nvim
            ui = {
              enable = false;
              # still specify checkboxes to influence toggle checkbox action
              checkboxes = {
                " " = {
                  char = "☐";
                  hl_group = "ObsidianTodo";
                };
                "x" = {
                  char = "✔";
                  hl_group = "ObsidianDone";
                };
              };
            };
          };
        };
      };
      custom.actionPickerLayers = {
        Notes = {
          leader = "<leader>n";
          icon = "";
          prefix = ":";
          suffix = "<CR>";
          actions = {
            d = {
              description = "Today's daily";
              action = "ObsidianToday";
            };
            D = {
              description = "Dailies";
              action = "ObsidianDailies";
            };
            n = {
              description = "New note";
              action = "ObsidianNew";
            };
            N = {
              description = "New from template";
              action = "ObsidianNewFromTemplate";
            };
            b = {
              description = "Backlinks";
              action = "ObsidianBacklinks";
            };
            p = {
              description = "Paste image";
              action = "ObsidianPasteImg";
            };
            P = {
              description = "Toggle preview";
              action = "MarkdownPreviewToggle";
            };
            e = {
              description = "Extract note";
              action = "ObsidianExtractNote";
            };
            k = {
              description = "Quick switch";
              action = "ObsidianQuickSwitch";
            };
            t = {
              description = "Tags";
              action = "ObsidianTags";
            };
            s = {
              description = "Search";
              action = "ObsidianSearch";
            };
            l = {
              description = "Link new";
              action = "ObsidianLinkNew";
            };
            c = {
              description = "Toggle checkbox";
              action = "ObsidianToggleCheckbox";
            };
            f = {
              description = "Follow link";
              action = "ObsidianFollowLink";
            };
          };
        };
      };
    };
  };
}
