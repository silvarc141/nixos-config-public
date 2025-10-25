{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.programs.zed-editor.enable {
    programs.zed-editor = {
      extensions = ["nix" "toml"];
      userSettings = {
        telemetry = {
          metrics = false;
        };
        vim_mode = true;
        ui_font_size = 16;
        buffer_font_size = 16;
        hour_format = "hour24";
        auto_update = false;
        base_keymap = "Emacs";
        load_direnv = "shell_hook";
        lsp = {
          nix = {
            binary = {
              path_lookup = true;
            };
          };
        };
        terminal = {
          program = "nu";
          detect_venv = {
            on = {
              directories = [".env" "env" ".venv" "venv"];
              activate_script = "default";
            };
          };
        };
        toolbar = {
          title = true;
        };
      };
    };
  };
}
