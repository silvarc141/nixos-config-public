{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.custom.nixvim.enable {
    programs.nixvim = {
      extraPlugins = [
        # not working right now, recheck when hm module is up to date with main himalaya
        # pkgs.vimPlugins.himalaya-vim
      ];
      extraConfigLua = ''
        -- vim.g.himalaya_folder_picker = 'telescope'
        -- vim.g.himalaya_folder_picker_telescope_preview = 1
      '';
      # custom.actionPickerLayers = {
      #   Email = {
      #     leader = "<leader>e";
      #     icon = "󰇰";
      #     prefix = ":Himalaya";
      #     suffix = "<CR>";
      #     actions = {
      #       e = {
      #         description = "List emails";
      #         action = "";
      #       };
      #       a = {
      #         description = "Attachments";
      #         action = "Attachments";
      #       };
      #       r = {
      #         description = "Reply";
      #         action = "Reply";
      #       };
      #       R = {
      #         description = "Reply to all";
      #         action = "ReplyAll";
      #       };
      #       f = {
      #         description = "List folders";
      #         action = "Folders";
      #       };
      #       m = {
      #         description = "Move email";
      #         action = "Move";
      #       };
      #       c = {
      #         description = "Compose new email";
      #         action = "Write";
      #       };
      #       n = {
      #         description = "Next page";
      #         action = "NextPage";
      #       };
      #       p = {
      #         description = "Previous page";
      #         action = "PreviousPage";
      #       };
      #     };
      #   };
      # };
    };
  };
}
