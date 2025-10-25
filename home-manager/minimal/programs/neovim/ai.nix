{
  config,
  lib,
  ...
}: {
  config = lib.mkIf (config.custom.nixvim.enable && config.custom.secrets.enable) {
    # TODO: disabled because of outdated config and long startup, reenable when fixed
    # programs.nixvim = {
    #   plugins.avante = {
    #     enable = true;
    #     settings = {
    #       auto_set_keymaps = false;
    #       auto_suggestions = false;
    #       provider = "claude";
    #       claude = {
    #         endpoint = "https://api.anthropic.com";
    #         max_tokens = 4096;
    #         model = "claude-3-5-sonnet-20240620";
    #         temperature = 0;
    #         api_key_name = "cmd:cat ${config.sops.secrets.anthropic-api-key.path}";
    #       };
    #       diff = {
    #         autojump = true;
    #         debug = false;
    #         list_opener = "copen";
    #       };
    #       mappings = {
    #         diff = {
    #           both = "cb";
    #           next = "]x";
    #           none = "c0";
    #           ours = "co";
    #           prev = "[x";
    #           theirs = "ct";
    #         };
    #       };
    #       windows = {
    #         sidebar_header = {
    #           align = "center";
    #           rounded = true;
    #         };
    #         width = 30;
    #         wrap = true;
    #       };
    #     };
    #   };
    #   custom.actionPickerLayers = {
    #     AI = {
    #       leader = "<leader>a";
    #       icon = "󰧑";
    #       isLua = true;
    #       prefix = "require('avante.api').";
    #       actions = {
    #         a = {
    #           description = "Ask";
    #           action = "ask()";
    #         };
    #         r = {
    #           description = "Refresh";
    #           action = "refresh()";
    #         };
    #       };
    #     };
    #   };
    # };
    # sops.secrets.anthropic-api-key = {};
    # custom.ephemeral = {
    #   local = {
    #     directories = [
    #       ".local/state/nvim/avante"
    #       ".local/share/nvim/avante"
    #     ];
    #   };
    #   ignored = {
    #     files = [
    #       ".config/github-copilot/versions.json"
    #     ];
    #   };
    # };
  };
}
