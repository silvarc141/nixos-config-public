{
  pkgs,
  config,
  ...
}: {
  environment = {
    systemPackages = with pkgs; [
      git
      curl
      wget
      pciutils
      usbutils
      inetutils
      e2fsprogs
      killall
      nmap
      neovim
    ];
    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    shellAliases.l = null;
  };
  users.users.${config.custom.mainUser.name}.shell = pkgs.nushell;
}
