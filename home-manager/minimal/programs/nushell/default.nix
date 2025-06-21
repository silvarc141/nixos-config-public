{
  lib,
  config,
  pkgs,
  ...
}: let
  # remember this exists: lib.hm.nushell.mkNushellInline
  nuConfig = {
    show_banner = false;
    table.index_mode = "auto";
    table.padding = {};
    rm.always_trash = false;
    cursor_shape.emacs = "block";
    menus = [
      {
        name = "completion_menu";
        only_buffer_difference = false;
        marker = "󰟃 ";
        type = {
          layout = "columnar";
          columns = 1;
          # col_padding = 2;
          # col_width = 20;
        };
        style = {
          text = "green";
          selected_text = "green_reverse";
          description_text = "yellow";
        };
      }
      {
        name = "help_menu";
        only_buffer_difference = true;
        marker = "󰋗 ";
        type = {
          layout = "description";
          columns = 4;
          col_width = 20;
          col_padding = 2;
          selection_rows = 4;
          description_rows = 10;
        };
        style = {
          text = "green";
          selected_text = "green_reverse";
          description_text = "yellow";
        };
      }
      {
        name = "history_menu";
        only_buffer_difference = true;
        marker = "󱍷 ";
        type = {
          layout = "list";
          page_size = 10;
        };
        style = {
          text = "green";
          selected_text = "green_reverse";
          description_text = "yellow";
        };
      }
    ];
    keybindings = [
      {
        name = "start_and_confirm_completion";
        modifier = "none";
        keycode = "tab";
        mode = ["emacs" "vi_insert"];
        event = {
          until = [
            {
              send = "menu";
              name = "completion_menu";
            }
            [
              {
                send = "enter";
              }
              # This makes it so that after completion, next completion completes if it can be instantly completed without opening a completion menu.
              # Constant / on text change completion is not yet possible in reedline.
              # Issue: https://github.com/nushell/reedline/issues/356
              # {
              #   send = "menu";
              #   name = "ide_completion_menu";
              # }
            ]
          ];
        };
      }
    ];
  };
in {
  config = lib.mkIf config.programs.nushell.enable {
    programs = {
      nushell = {
        shellAliases = {
          l = "ls";
          la = "ls -a";
          ll = "ls -l";
          "+" = "nix-shell --command nu -p";
          nr = "nixos-rebuild";
          snr = "sudo nixos-rebuild";
          snrs = "sudo nixos-rebuild switch";
          snrb = "sudo nixos-rebuild boot";
          a = "act-on-path";
        };
        extraConfig = lib.mkMerge [
          # NUON is a superset of JSON
          "$env.config = ${builtins.toJSON nuConfig}"
          # Override back PROMPT_INDICATOR, as it's needed for proper prompt change based on the current reedline menu.
          # Without an active menu, it's just appended at the end.
          # Not tested with transient or right prompt.
          (lib.mkAfter "$env.PROMPT_INDICATOR = $'(ansi {fg: cyan_dimmed})󰬪 '")
          # Source lib.nu after integrations to use them inside
          (lib.mkAfter "source ${./lib.nu}")
        ];
        plugins = with pkgs.nushellPlugins; [
          formats
        ];
      };
      carapace = {
        enable = true;
        enableNushellIntegration = true;
      };
      nix-your-shell = {
        enable = true;
        enableNushellIntegration = true;
      };
      starship = {
        enable = true;
        enableNushellIntegration = true;
        settings = {
          add_newline = true;
          format = ''
            [┌─󰸵 ](bold purple)$directory$battery$all$character
          '';
          character = {
            format = "$symbol";
            success_symbol = "[└─](bold green)";
            error_symbol = "[└─](bold red)";
          };
          continuation_prompt = "[─┤](bright-black)";
          custom = {
            unity = {
              detect_folders = ["Assets" "ProjectSettings"];
              symbol = "󰚯 Unity ";
              style = "bold white";
            };
            sudo = {
              format = "[$symbol$output]($style) ";
              symbol = " ";
              style = "bold fg:bright-red";
              when = "sudo -vn";
            };
          };
        };
      };
    };
    custom.ephemeral.local = {
      files = [".config/nushell/history.txt"];
    };
  };
}
