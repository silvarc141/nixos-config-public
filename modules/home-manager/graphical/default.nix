args @ {
  lib,
  nixosConfig,
  pkgs,
  ...
}:
with lib; {
  imports = [
    ./theme.nix
    ./firefox.nix
    ./flatpak.nix
    ./qutebrowser.nix
    ./dunst.nix
    ./feh.nix
    ./rider.nix
    ./unity.nix
    ./plastic-scm.nix
    (import ./hyprland (args // {enable = nixosConfig.capabilities.graphical.hyprland.enable;}))
  ];

  config = mkIf nixosConfig.capabilities.graphical.enable {
    xdg.portal = {
      enable = true;
      config.common.default = "*";
    };

    xdg.mime.enable = true;
    xdg.mimeApps = {
      enable = true;
      associations.added = {
        "text/plain" = ["neovide.desktop"];
        "application/pdf" = ["org.pwmt.zathura.desktop"];
        "video/*" = ["mpv.desktop"];
        "image/*" = ["feh.desktop"];
      };
      defaultApplications = {
        "text/plain" = ["neovide.desktop"];
        "application/pdf" = ["org.pwmt.zathura.desktop"];
        "video/*" = ["mpv.desktop"];
        "image/*" = ["feh.desktop"];
      };
    };

    home.sessionVariables = {
      TERM = "alacritty";
    };

    services.gnome-keyring.enable = true;

    programs.obs-studio.enable = true;
    programs.mpv.enable = true;
    programs.zathura.enable = true;

    home.packages = with pkgs; [
      keepassxc
      neovide
      gimp
      deluge

      discord
      vesktop
      beeper

      reaper
      lsp-plugins
      vital

      brogue-ce
    ];
  };
}
