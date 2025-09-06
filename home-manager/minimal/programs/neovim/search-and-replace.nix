{
  config,
  lib,
  ...
}: {
  # temp disabled for blocking rebuild by failing tests
  # config = lib.mkIf config.custom.nixvim.enable {
  #   programs.nixvim = {
  #     plugins.grug-far.enable = true;
  #     keymaps = [
  #       {
  #         mode = ["n"];
  #         key = "<C-s>";
  #         action = config.lib.nixvim.mkRaw "function() require('grug-far').open({ transient = true }) end";
  #       }
  #     ];
  #   };
  # };
}
