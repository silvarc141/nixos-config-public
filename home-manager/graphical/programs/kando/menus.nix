{
  lib,
  config,
  pkgs,
  ...
}: {
  config = lib.mkIf config.programs.kando.enable {
    programs.kando = {
      menus = let
        iconTheme = "material-symbols-rounded";
        iconThemeDesktopEntries = "papirus-dark";
        inherit (config.programs.nushell.lib) writeNuSnippet writeNuScriptBinLib;

        parseDesktopEntry = content: key: let
          lines = lib.splitString "\n" content;
          prefix = "${key}=";
          mappedLines = map (line:
            if lib.hasPrefix prefix line
            then line
            else null)
          lines;
          matchingLines = lib.filter (line: line != null) mappedLines;
        in
          if matchingLines != []
          then lib.elemAt (lib.splitString "=" (lib.head matchingLines)) 1
          else null;

        packageToKandoItem = pkg: let
          desktopDir = "${pkg}/share/applications";
          desktopFileNames =
            if builtins.pathExists desktopDir
            then lib.attrNames (builtins.readDir desktopDir)
            else [];
          potentialItems =
            map (
              fileName:
                if !(lib.hasSuffix ".desktop" fileName)
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
          validItems = lib.filter (item: item != null) potentialItems;
        in
          if validItems != []
          then lib.head validItems
          else null;

        normalizedXdgFilenames = map (
          name:
            if lib.hasSuffix ".desktop" name
            then name
            else "${name}.desktop"
        ) (lib.attrNames config.xdg.desktopEntries);

        processedPkgs = lib.filter (p: p != null) (map packageToKandoItem config.home.packages);
        filteredPkgs = lib.filter (p: !(lib.elem p.fileName normalizedXdgFilenames)) processedPkgs;

        itemsFromPkgs = map (p: p.item) filteredPkgs;
        itemsFromXdg = lib.filter (item: item != null) (
          lib.mapAttrsToList (
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
                type = "command";
                data = {
                  command = writeNuSnippet "hyprctl dispatch fullscreen";
                  delayed = true;
                };
                name = "Fullscreen";
                icon = "fullscreen";
                inherit iconTheme;
              }
              {
                type = "submenu";
                data = {};
                name = "Settings";
                icon = "settings";
                inherit iconTheme;
                children = [
                  {
                    type = "submenu";
                    data = {};
                    name = "Window";
                    icon = "select_window_2";
                    inherit iconTheme;
                    children = [
                      {
                        type = "command";
                        data = {
                          command = writeNuSnippet "hyprctl dispatch togglefloating";
                          delayed = true;
                        };
                        name = "Float";
                        icon = "float_landscape_2";
                        inherit iconTheme;
                      }
                      {
                        type = "command";
                        data = {
                          command = writeNuSnippet "hyprctl dispatch pin";
                          delayed = true;
                        };
                        name = "Pin";
                        icon = "pinboard";
                        inherit iconTheme;
                      }
                      {
                        type = "command";
                        data = {
                          command = writeNuSnippet "hyprctl dispatch forcekillactive";
                          delayed = true;
                        };
                        name = "Kill";
                        icon = "tab_close";
                        inherit iconTheme;
                      }
                      {
                        type = "command";
                        data = {
                          command = writeNuSnippet "hyprctl dispatch pseudo";
                          delayed = true;
                        };
                        name = "Pseudo";
                        icon = "aspect_ratio";
                        inherit iconTheme;
                      }
                    ];
                  }
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
                          command = "systemctl reboot";
                          delayed = false;
                        };
                        name = "Restart";
                        icon = "restart_alt";
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
                        inherit iconTheme;
                      }
                      {
                        type = "command";
                        data = {
                          command = "systemctl hibernate";
                          delayed = false;
                        };
                        name = "Hibernate";
                        icon = "nightlight";
                        inherit iconTheme;
                      }
                      {
                        type = "command";
                        data = {
                          command = "systemctl poweroff";
                          delayed = false;
                        };
                        name = "Shutdown";
                        icon = "power_settings_new";
                        inherit iconTheme;
                      }
                    ];
                  }
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
                  {
                    type = "command";
                    data = {
                      command = lib.getExe pkgs.helvum;
                      delayed = false;
                    };
                    name = "Routing";
                    icon = "cable";
                    inherit iconTheme;
                  }
                  {
                    type = "command";
                    data = {
                      command = lib.getExe pkgs.pavucontrol;
                      delayed = false;
                    };
                    name = "Audio";
                    icon = "sound_detection_loud_sound";
                    inherit iconTheme;
                  }
                ];
              }
              {
                type = "command";
                data = {
                  command = writeNuSnippet "hyprctl dispatch killactive";
                  delayed = true;
                };
                name = "Close";
                icon = "close";
                inherit iconTheme;
              }
              {
                type = "submenu";
                data = {};
                name = "Open";
                icon = "apps";
                inherit iconTheme;
                children = desktopEntryKandoItems;
              }
            ];
          };
          shortcut = "";
          shortcutID = "main";
          centered = false;
          warpMouse = false;
          anchored = false;
          hoverMode = true;
        }
      ];
    };
  };
}
