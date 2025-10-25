{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.custom.nixvim.enable {
    programs.nixvim = {
      clipboard = {
        register = "unnamedplus";
        providers.wl-copy.enable = config.wayland.windowManager.hyprland.enable;
      };
      # consider yanky and img-clip
      # plugins = {
      #   yanky = {
      #     enable = true;
      #     enableTelescope = true;
      #   };
      # };
      # extraPlugins = with pkgs.vimPlugins; [img-clip-nvim];
      # extraConfigLuaPost = ''
      #   require('img-clip').setup({
      #     default = {
      #       embed_image_as_base64 = false,
      #       prompt_for_file_name = false,
      #       drag_and_drop = {
      #         insert_mode = true,
      #       },
      #       -- required for Windows users
      #       use_absolute_path = true,
      #     },
      #   })
      # '';
    };
  };
}
