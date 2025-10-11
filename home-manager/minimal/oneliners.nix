{pkgs, ...}: {
  config = {
    home.packages = [
      (pkgs.writeShellScriptBin "which-deep" ''readlink -f "$(which "$1")"'')
    ];
  };
}
