{
  lib,
  config,
  pkgs,
  ...
}: {
  config = lib.mkIf config.programs.kando.enable {
    programs.kando = {
      menus = let
        inherit (lib) getExe mapAttrsToList elem head splitString filter elemAt attrNames hasPrefix hasSuffix imap1;
        inherit (lib.strings) sanitizeDerivationName;
        inherit (config.programs.nushell.lib) writeNuScriptBinLib;

        iconTheme = "material-symbols-rounded";
        iconThemeDesktopEntries = "papirus-dark";

        mkFocusPreviousCommand = finalCommand:
          getExe (writeNuScriptBinLib "focus-previous-then-${sanitizeDerivationName finalCommand}" ''
            let prev = sys hypr previous-focus-in-active-workspace

            if ($prev != null) {
              let pid = $prev | get pid
              hyprctl dispatch focuswindow pid:($pid)

              # HACK: focus window may be too slow on some machines
              sleep 0.1sec
            };

            ${finalCommand}
          '');

        parseDesktopEntry = content: key: let
          lines = splitString "\n" content;
          prefix = "${key}=";
          mappedLines = map (line:
            if hasPrefix prefix line
            then line
            else null)
          lines;
          matchingLines = filter (line: line != null) mappedLines;
        in
          if matchingLines != []
          then elemAt (splitString "=" (head matchingLines)) 1
          else null;

        packageToKandoItem = pkg: let
          desktopDir = "${pkg}/share/applications";
          desktopFileNames =
            if builtins.pathExists desktopDir
            then attrNames (builtins.readDir desktopDir)
            else [];
          potentialItems =
            map (
              fileName:
                if !(hasSuffix ".desktop" fileName)
                then null
                else let
                  content = builtins.readFile "${desktopDir}/${fileName}";
                  name = parseDesktopEntry content "Name";
                  exec = parseDesktopEntry content "Exec";
                  icon = parseDesktopEntry content "Icon";
                  noDisplay = parseDesktopEntry content "NoDisplay" == "true";
                  isValid = name != null && exec != null && !noDisplay;
                  cleanExec = builtins.replaceStrings [" %u" " %U" " %f" " %F"] ["" "" "" ""] exec;
                  commandMatch = builtins.match ''.*(/nix/store[^"]*)"*'' cleanExec;
                  command =
                    if commandMatch != null && commandMatch != []
                    then cleanExec
                    else "${pkg}/bin/${cleanExec}";
                in
                  if isValid
                  then {
                    inherit fileName;
                    item = {
                      type = "command";
                      data = {
                        command = command;
                        delayed = false;
                      };
                      inherit name icon;
                      iconTheme = iconThemeDesktopEntries;
                    };
                  }
                  else null
            )
            desktopFileNames;
          validItems = filter (item: item != null) potentialItems;
        in
          if validItems != []
          then head validItems
          else null;

        normalizedXdgFilenames = map (
          name:
            if hasSuffix ".desktop" name
            then name
            else "${name}.desktop"
        ) (attrNames config.xdg.desktopEntries);

        processedPkgs = filter (p: p != null) (map packageToKandoItem config.home.packages);
        filteredPkgs = filter (p: !(elem p.fileName normalizedXdgFilenames)) processedPkgs;

        itemsFromPkgs = map (p: p.item) filteredPkgs;
        itemsFromXdg = filter (item: item != null) (
          mapAttrsToList (
            fileName: entry:
              if (entry.noDisplay or false)
              then null
              else {
                type = "command";
                data = {
                  command = entry.exec;
                  delayed = false;
                };
                inherit (entry) name icon;
                iconTheme = iconThemeDesktopEntries;
              }
          )
          config.xdg.desktopEntries
        );

        desktopEntryKandoItems = map (i: i // {icon = "${i.icon}.svg";}) (itemsFromPkgs ++ itemsFromXdg);
      in [
        {
          root = {
            type = "submenu";
            name = "Main";
            icon = "menu";
            inherit iconTheme;
            children = [
              {
                type = "submenu";
                data = {};
                name = "Open";
                icon = "apps";
                angle = 0;
                inherit iconTheme;
                children = desktopEntryKandoItems;
              }
              {
                type = "submenu";
                data = {};
                name = "Window";
                icon = "select_window_2";
                angle = 90;
                inherit iconTheme;
                children = [
                  {
                    type = "command";
                    data = {
                      command = mkFocusPreviousCommand "hyprctl dispatch fullscreen";
                      delayed = false;
                    };
                    name = "Fullscreen";
                    icon = "fullscreen";
                    angle = 0;
                    inherit iconTheme;
                  }
                  {
                    type = "submenu";
                    data = {};
                    name = "Send";
                    icon = "move_down";
                    angle = 60;
                    inherit iconTheme;
                    children = let
                      workspaceNames = ["Q" "W" "E" "R" "T" "1" "2" "3" "4" "5" "N" "M" "," "." "/"];
                      mkWorkspace = id: name: {
                        type = "command";
                        data = {
                          command = mkFocusPreviousCommand "hyprctl dispatch movetoworkspacesilent ${id}";
                          delayed = false;
                        };
                        icon = "window_closed";
                        inherit iconTheme name;
                      };
                      workspaceMenu = imap1 (i: v: mkWorkspace (toString i) v) workspaceNames;
                    in
                      workspaceMenu;
                  }
                  {
                    type = "submenu";
                    data = {};
                    name = "More";
                    icon = "more_horiz";
                    angle = 120;
                    inherit iconTheme;
                    children = [
                      {
                        type = "command";
                        data = {
                          command = mkFocusPreviousCommand "hyprctl dispatch togglefloating";
                          delayed = false;
                        };
                        name = "Float";
                        icon = "float_landscape_2";
                        inherit iconTheme;
                      }
                      {
                        type = "command";
                        data = {
                          command = mkFocusPreviousCommand "hyprctl dispatch pin";
                          delayed = false;
                        };
                        name = "Pin";
                        icon = "pinboard";
                        inherit iconTheme;
                      }
                      {
                        type = "command";
                        data = {
                          command = mkFocusPreviousCommand "hyprctl dispatch forcekillactive";
                          delayed = false;
                        };
                        name = "Kill";
                        icon = "tab_close";
                        inherit iconTheme;
                      }
                      {
                        type = "command";
                        data = {
                          command = mkFocusPreviousCommand "hyprctl dispatch pseudo";
                          delayed = false;
                        };
                        name = "Pseudo";
                        icon = "aspect_ratio";
                        inherit iconTheme;
                      }
                    ];
                  }
                  {
                    type = "command";
                    data = {
                      command = mkFocusPreviousCommand "hyprctl dispatch killactive";
                      delayed = false;
                    };
                    name = "Close";
                    icon = "close";
                    angle = 180;
                    inherit iconTheme;
                  }
                ];
              }
              {
                type = "submenu";
                data = {};
                name = "Settings";
                icon = "settings";
                angle = 180;
                inherit iconTheme;
                children = [
                  {
                    type = "submenu";
                    data = {};
                    name = "Power";
                    icon = "settings_power";
                    inherit iconTheme;
                    children = [
                      {
                        type = "command";
                        data = {
                          command = "systemctl poweroff";
                          delayed = false;
                        };
                        name = "Shutdown";
                        icon = "power_settings_new";
                        angle = 0;
                        inherit iconTheme;
                      }
                      {
                        type = "command";
                        data = {
                          command = "loginctl lock-session";
                          delayed = false;
                        };
                        name = "Lock";
                        icon = "lock";
                        angle = 90;
                        inherit iconTheme;
                      }
                      {
                        type = "command";
                        data = {
                          command = "systemctl reboot";
                          delayed = false;
                        };
                        name = "Restart";
                        icon = "restart_alt";
                        angle = 180;
                        inherit iconTheme;
                      }
                    ];
                  }
                  {
                    type = "submenu";
                    data = {};
                    name = "Connections";
                    icon = "settings_input_antenna";
                    inherit iconTheme;
                    children = [
                      {
                        type = "command";
                        data = {
                          command = "${pkgs.blueman}/bin/blueman-manager";
                          delayed = false;
                        };
                        name = "Bluetooth";
                        icon = "bluetooth";
                        inherit iconTheme;
                      }
                      {
                        type = "command";
                        data = {
                          command = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
                          delayed = false;
                        };
                        name = "Internet";
                        icon = "wifi";
                        inherit iconTheme;
                      }
                    ];
                  }
                  {
                    type = "submenu";
                    data = {};
                    name = "Audio";
                    icon = "sound_detection_loud_sound";
                    inherit iconTheme;
                    children = [
                      {
                        type = "command";
                        data = {
                          command = getExe pkgs.helvum;
                          delayed = false;
                        };
                        name = "Routing";
                        icon = "cable";
                        inherit iconTheme;
                      }
                      {
                        type = "command";
                        data = {
                          command = getExe pkgs.pavucontrol;
                          delayed = false;
                        };
                        name = "Sound";
                        icon = "equalizer";
                        inherit iconTheme;
                      }
                    ];
                  }
                ];
              }
            ];
          };
          shortcut = "";
          shortcutID = "main";
          centered = config.wayland.windowManager.hyprland.touchscreen.enable;
          warpMouse = false;
          anchored = false;
          hoverMode = true;
        }
      ];
    };
  };
}
