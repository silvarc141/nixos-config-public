{
  lib,
  config,
  pkgs,
  ...
}: {
  config = lib.mkIf config.programs.kando.enable {
    custom.ephemeral.data.files = [".config/kando/menus.json"];
    # programs.kando = {
    #   menus = let
    #     inherit (config.programs.nushell.lib) mkNuScriptlet;
    #     cmd = config.custom.graphical.desktopAgnostic.extraCommands;
    #   in [
    #     {
    #       root = {
    #         type = "submenu";
    #         name = "Main";
    #         icon = "menu";
    #         iconTheme = "material-symbols-rounded";
    #         children = [
    #           {
    #             type = "submenu";
    #             data = {};
    #             name = "Open App";
    #             icon = "apps";
    #             iconTheme = "material-symbols-rounded";
    #             children = [
    #               {
    #                 type = "command";
    #                 data = {
    #                   command = cmd.fileManager;
    #                   delayed = false;
    #                 };
    #                 name = "Files";
    #                 icon = "folder";
    #                 iconTheme = "material-symbols-rounded";
    #               }
    #               {
    #                 type = "command";
    #                 data = {
    #                   command = cmd.terminalEmulator;
    #                   delayed = false;
    #                 };
    #                 name = "Terminal";
    #                 icon = "terminal";
    #                 iconTheme = "material-symbols-rounded";
    #               }
    #               {
    #                 type = "submenu";
    #                 data = {};
    #                 name = "More";
    #                 icon = "more_horiz";
    #                 iconTheme = "material-symbols-rounded";
    #                 children = [
    #                   {
    #                     type = "command";
    #                     data = {
    #                       command = cmd.passwordManagerOpen;
    #                       delayed = false;
    #                     };
    #                     name = "Password Manager";
    #                     icon = "password";
    #                     iconTheme = "material-symbols-rounded";
    #                   }
    #                   {
    #                     type = "command";
    #                     data = {
    #                       command = lib.getExe pkgs.vesktop;
    #                       delayed = false;
    #                     };
    #                     name = "Discord";
    #                     icon = "chat_bubble";
    #                     iconTheme = "material-symbols-rounded";
    #                   }
    #                 ];
    #               }
    #               {
    #                 type = "submenu";
    #                 data = {};
    #                 name = "Settings";
    #                 icon = "settings";
    #                 iconTheme = "material-symbols-rounded";
    #                 children = [
    #                   {
    #                     type = "command";
    #                     data = {
    #                       command = "${pkgs.blueman}/bin/blueman-manager";
    #                       delayed = false;
    #                     };
    #                     name = "Bluetooth";
    #                     icon = "bluetooth";
    #                     iconTheme = "material-symbols-rounded";
    #                   }
    #                   {
    #                     type = "command";
    #                     data = {
    #                       command = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
    #                       delayed = false;
    #                     };
    #                     name = "Internet";
    #                     icon = "wifi";
    #                     iconTheme = "material-symbols-rounded";
    #                   }
    #                   {
    #                     type = "command";
    #                     data = {
    #                       command = lib.getExe pkgs.helvum;
    #                       delayed = false;
    #                     };
    #                     name = "Routing";
    #                     icon = "cable";
    #                     iconTheme = "material-symbols-rounded";
    #                   }
    #                   {
    #                     type = "command";
    #                     data = {
    #                       command = lib.getExe pkgs.pavucontrol;
    #                       delayed = false;
    #                     };
    #                     name = "Audio";
    #                     icon = "sound_detection_loud_sound";
    #                     iconTheme = "material-symbols-rounded";
    #                   }
    #                 ];
    #               }
    #               {
    #                 type = "command";
    #                 data = {
    #                   command = cmd.browser;
    #                   delayed = false;
    #                 };
    #                 name = "Browser";
    #                 icon = "globe";
    #                 iconTheme = "material-symbols-rounded";
    #               }
    #             ];
    #           }
    #           {
    #             type = "submenu";
    #             data = {};
    #             name = "Current Window";
    #             icon = "select_window_2";
    #             iconTheme = "material-symbols-rounded";
    #             children = [
    #               {
    #                 type = "command";
    #                 data = {
    #                   command = mkNuScriptlet ''
    #                     let lastFocusedPid = sys clients | where focusHistoryID == 1 | first | get pid
    #                     hyprctl dispatch closewindow pid:($lastFocusedPid)
    #                   '';
    #                   delayed = false;
    #                 };
    #                 name = "Close";
    #                 icon = "close";
    #                 iconTheme = "material-symbols-rounded";
    #               }
    #               {
    #                 type = "command";
    #                 data = {
    #                   command = mkNuScriptlet ''
    #                     let lastFocusedPid = sys clients | where focusHistoryID == 1 | first | get pid
    #                     hyprctl dispatch focuswindow pid:($lastFocusedPid)
    #                     hyprctl dispatch fullscreen
    #                   '';
    #                   delayed = false;
    #                 };
    #                 name = "Fullscreen";
    #                 icon = "fullscreen";
    #                 iconTheme = "material-symbols-rounded";
    #               }
    #               {
    #                 type = "command";
    #                 data = {
    #                   command = ''
    #                     let lastFocusedPid = sys clients | where focusHistoryID == 1 | first | get pid
    #                     hyprctl dispatch togglefloating pid:($lastFocusedPid)
    #                   '';
    #                   delayed = false;
    #                 };
    #                 name = "Float";
    #                 icon = "float_landscape_2";
    #                 iconTheme = "material-symbols-rounded";
    #               }
    #               {
    #                 type = "submenu";
    #                 data = {};
    #                 name = "More";
    #                 icon = "more_horiz";
    #                 iconTheme = "material-symbols-rounded";
    #                 children = [
    #                   {
    #                     type = "command";
    #                     data = {
    #                       command = ''
    #                         let lastFocusedPid = sys clients | where focusHistoryID == 1 | first | get pid
    #                         hyprctl dispatch pin pid:($lastFocusedPid)
    #                       '';
    #                       delayed = false;
    #                     };
    #                     name = "Pin";
    #                     icon = "pinboard";
    #                     iconTheme = "material-symbols-rounded";
    #                   }
    #                   {
    #                     type = "command";
    #                     data = {
    #                       command = ''
    #                         let lastFocusedPid = sys clients | where focusHistoryID == 1 | first | get pid
    #                         hyprctl dispatch killwindow pid:($lastFocusedPid)
    #                       '';
    #                       delayed = false;
    #                     };
    #                     name = "Kill";
    #                     icon = "tab_close";
    #                     iconTheme = "material-symbols-rounded";
    #                   }
    #                   {
    #                     type = "command";
    #                     data = {
    #                       command = ''
    #                         let lastFocusedPid = sys clients | where focusHistoryID == 1 | first | get pid
    #                         hyprctl dispatch pseudo pid:($lastFocusedPid)
    #                       '';
    #                       delayed = false;
    #                     };
    #                     name = "Pseudo";
    #                     icon = "aspect_ratio";
    #                     iconTheme = "material-symbols-rounded";
    #                   }
    #                 ];
    #               }
    #             ];
    #           }
    #           {
    #             type = "submenu";
    #             data = {};
    #             name = "Power";
    #             icon = "settings_power";
    #             iconTheme = "material-symbols-rounded";
    #             children = [
    #               {
    #                 type = "command";
    #                 data = {
    #                   command = "";
    #                   delayed = false;
    #                 };
    #                 name = "Restart";
    #                 icon = "restart_alt";
    #                 iconTheme = "material-symbols-rounded";
    #               }
    #               {
    #                 type = "command";
    #                 data = {
    #                   command = "";
    #                   delayed = false;
    #                 };
    #                 name = "Lock";
    #                 icon = "lock";
    #                 iconTheme = "material-symbols-rounded";
    #               }
    #               {
    #                 type = "command";
    #                 data = {
    #                   command = "";
    #                   delayed = false;
    #                 };
    #                 name = "Hibernate";
    #                 icon = "nightlight";
    #                 iconTheme = "material-symbols-rounded";
    #               }
    #               {
    #                 type = "command";
    #                 data = {
    #                   command = "";
    #                   delayed = false;
    #                 };
    #                 name = "Shutdown";
    #                 icon = "power_settings_new";
    #                 iconTheme = "material-symbols-rounded";
    #               }
    #             ];
    #           }
    #           {
    #             type = "submenu";
    #             data = {};
    #             name = "Workspace";
    #             icon = "window_closed";
    #             iconTheme = "material-symbols-rounded";
    #             children = [
    #               {
    #                 type = "submenu";
    #                 data = {};
    #                 name = "Workspaces N-/";
    #                 icon = "special_character";
    #                 iconTheme = "material-symbols-rounded";
    #                 children = [
    #                   {
    #                     type = "command";
    #                     data = {
    #                       command = "";
    #                       delayed = false;
    #                     };
    #                     name = "Run Command";
    #                     icon = "terminal";
    #                     iconTheme = "material-symbols-rounded";
    #                   }
    #                   {
    #                     type = "command";
    #                     data = {
    #                       command = "";
    #                       delayed = false;
    #                     };
    #                     name = "Run Command";
    #                     icon = "terminal";
    #                     iconTheme = "material-symbols-rounded";
    #                   }
    #                   {
    #                     type = "command";
    #                     data = {
    #                       command = "";
    #                       delayed = false;
    #                     };
    #                     name = "Run Command";
    #                     icon = "terminal";
    #                     iconTheme = "material-symbols-rounded";
    #                   }
    #                   {
    #                     type = "command";
    #                     data = {
    #                       command = "";
    #                       delayed = false;
    #                     };
    #                     name = "Run Command";
    #                     icon = "terminal";
    #                     iconTheme = "material-symbols-rounded";
    #                   }
    #                   {
    #                     type = "command";
    #                     data = {
    #                       command = "";
    #                       delayed = false;
    #                     };
    #                     name = "Run Command";
    #                     icon = "terminal";
    #                     iconTheme = "material-symbols-rounded";
    #                   }
    #                 ];
    #               }
    #               {
    #                 type = "submenu";
    #                 data = {};
    #                 name = "Workspaces 1-5";
    #                 icon = "123";
    #                 iconTheme = "material-symbols-rounded";
    #                 children = [
    #                   {
    #                     type = "command";
    #                     data = {
    #                       command = "";
    #                       delayed = false;
    #                     };
    #                     name = "Run Command";
    #                     icon = "terminal";
    #                     iconTheme = "material-symbols-rounded";
    #                   }
    #                   {
    #                     type = "command";
    #                     data = {
    #                       command = "";
    #                       delayed = false;
    #                     };
    #                     name = "Run Command";
    #                     icon = "terminal";
    #                     iconTheme = "material-symbols-rounded";
    #                   }
    #                   {
    #                     type = "command";
    #                     data = {
    #                       command = "";
    #                       delayed = false;
    #                     };
    #                     name = "Run Command";
    #                     icon = "terminal";
    #                     iconTheme = "material-symbols-rounded";
    #                   }
    #                   {
    #                     type = "command";
    #                     data = {
    #                       command = "";
    #                       delayed = false;
    #                     };
    #                     name = "Run Command";
    #                     icon = "terminal";
    #                     iconTheme = "material-symbols-rounded";
    #                   }
    #                   {
    #                     type = "command";
    #                     data = {
    #                       command = "";
    #                       delayed = false;
    #                     };
    #                     name = "Run Command";
    #                     icon = "terminal";
    #                     iconTheme = "material-symbols-rounded";
    #                   }
    #                 ];
    #               }
    #               {
    #                 type = "submenu";
    #                 data = {};
    #                 name = "Workspace Q-T";
    #                 icon = "abc";
    #                 iconTheme = "material-symbols-rounded";
    #                 children = [
    #                   {
    #                     type = "command";
    #                     data = {
    #                       command = "";
    #                       delayed = false;
    #                     };
    #                     name = "Run Command";
    #                     icon = "terminal";
    #                     iconTheme = "material-symbols-rounded";
    #                   }
    #                   {
    #                     type = "command";
    #                     data = {
    #                       command = "";
    #                       delayed = false;
    #                     };
    #                     name = "Run Command";
    #                     icon = "terminal";
    #                     iconTheme = "material-symbols-rounded";
    #                   }
    #                   {
    #                     type = "command";
    #                     data = {
    #                       command = "";
    #                       delayed = false;
    #                     };
    #                     name = "Run Command";
    #                     icon = "terminal";
    #                     iconTheme = "material-symbols-rounded";
    #                   }
    #                   {
    #                     type = "command";
    #                     data = {
    #                       command = "";
    #                       delayed = false;
    #                     };
    #                     name = "Run Command";
    #                     icon = "terminal";
    #                     iconTheme = "material-symbols-rounded";
    #                   }
    #                   {
    #                     type = "command";
    #                     data = {
    #                       command = "";
    #                       delayed = false;
    #                     };
    #                     name = "Run Command";
    #                     icon = "terminal";
    #                     iconTheme = "material-symbols-rounded";
    #                   }
    #                 ];
    #               }
    #             ];
    #           }
    #         ];
    #       };
    #       shortcut = "";
    #       shortcutID = "main";
    #       centered = false;
    #       warpMouse = false;
    #       anchored = false;
    #       hoverMode = true;
    #     }
    #   ];
    # };
  };
}
