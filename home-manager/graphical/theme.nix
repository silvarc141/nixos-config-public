{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.custom;
in {
  imports = [inputs.catppuccin.homeManagerModules.catppuccin];

  config = lib.mkIf cfg.graphical.enable {
    catppuccin = {
      enable = true;
      flavor = "mocha";
      gtk = {
        enable = true;
        size = "compact";
        icon.enable = true;
      };
      kvantum.enable = true;

      # not practical
      zathura.enable = false;

      # out of date, issue with extraConfig vs settings
      mako.enable = false;
    };

    home.pointerCursor = {
      x11.enable = true;
      gtk.enable = true;
      hyprcursor.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
    };

    qt = {
      enable = true;
      style.name = "kvantum";
      platformTheme.name = "kvantum";
    };

    gtk.enable = true;

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };

    custom.ephemeral = {
      local = {
        directories = [
          # for gtkfilechooser.ini which gets replaced if its a single persisted file
          ".config/gtk-2.0"
        ];
        files = [
          ".config/QtProject.conf"
        ];
      };
      ignored = {
        files = [".config/dconf/user"];
      };
    };
  };
}
