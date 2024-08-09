{
  pkgs,
  config,
  lib,
  ...
}: let
  flakeDir = "~/nixos-config";
  logDir = "~/.buildlogs";
in {
  options.commands.rebuild.enable = lib.mkEnableOption "enable rebuild command";

  config = lib.mkIf config.commands.rebuild.enable {
    home.packages = with pkgs; [
      (writeShellScriptBin "rebuild" ''
        set -e
        pushd ${flakeDir} >/dev/null

        echo -e "\e[34mFormatting...\e[39m"
        alejandra -q ./

        git --no-pager diff -U0

        echo -e "\e[34mRebuilding...\e[39m"
        mkdir -p ${logDir}
        logFile=${logDir}current-generation.log
        sudo nixos-rebuild switch --flake . &>$logFile || (cat $logFile | grep --color error && false)

        genName=$(nixos-rebuild list-generations | grep current | awk -F " " '{print $3"_"$4}')
        finalLogFile=${logDir}''${genName}.log
        mv $logFile $finalLogFile
        echo "Full log stored in $finalLogFile"

        echo -e "\e[34mCommitting...\e[39m"
        git add *
        git commit -qm "$genName"

        echo -e "\e[34mPushing...\e[39m"
        git push
        popd >/dev/null
        ${libnotify}/bin/notify-send -e "Rebuilding finished." --app-name=System
      '')
    ];
  };
}
