# remember this exists: lib.hm.nushell.mkNushellInline
{
  show_banner = false;
  table.index_mode = "auto";
  table.mode = "light";
  table.padding = {};
  table.show_empty = false;
  table.header_on_separator = true;
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
          ]
        ];
      };
    }
  ];
}
