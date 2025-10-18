let
  sections = {
    main = 0;
    mainAlt = 100;
    midi = 32060;
    midiEventList = 32061;
    midiInline = 32062;
    mediaExplorer = 32063;
  };

  getExtraScriptPath = name: "nix/${name}.lua";
in
  {
    pkgs,
    lib,
    config,
    ...
  }: let
    inherit
      (lib)
      mkIf
      mkOption
      types
      mkEnableOption
      literalExpression
      mapAttrs
      genAttrs
      foldlAttrs
      concatStringsSep
      mapAttrsToList
      filter
      concatLines
      attrValues
      optionals
      ;

    inherit (lib.strings) charToInt;

    cfg = config.programs.reaper;

    sectionOption = mkOption {
      type = with types; enum (attrNames sections);
      default = "main";
      description = "Section to which the option is applied.";
    };
  in {
    imports = [
      ./settings.nix
    ];

    options.programs.reaper = {
      enable = mkEnableOption "reaper digital audio workstation";

      package = mkOption {
        type = types.package;
        default = pkgs.reaper;
        defaultText = literalExpression "pkgs.reaper";
        description = "The package to use for REAPER.";
      };

      reaPackPackages = mkOption {
        type = types.listOf types.package;
        default = [];
        description = ''
          List of ReaPack packages to put into REAPER config directory.
          Expects a derivation packaged in the format of [reapkgs](https://github.com/silvarc141/reapkgs).
          ReaPack "known" repos are pre-packaged [here](https://github.com/silvarc141/reapkgs-known).
        '';
      };

      extraScripts = mkOption {
        type = with types;
          attrsOf (submodule {
            options = {
              name = mkOption {
                type = nullOr str;
                default = null;
                description = "If not set, defaults to attribute name.";
              };
              text = mkOption {
                type = str;
                description = "Text content of the script";
              };
              section = sectionOption;
            };
          });
        default = {};
        description = "Extra lua scripts to include";
      };

      extraJSFX = mkOption {
        type = with types; attrsOf str;
        default = {};
        description = "Extra JSFX to include";
      };

      libSwellTheme = mkOption {
        type = with types; str;
        default = ''
          default_font_size 13
          menubar_height 22
          menubar_font_size 13
          menubar_spacing_width 11
          menubar_margin_width 10
          scrollbar_width 14
          scrollbar_min_thumb_height 4
          combo_height 22
          _3dface #333333
          _3dshadow #222222
          _3dhilight #808080
          _3ddkshadow #303030
          button_text #b0b0b0
          button_text_disabled #808080
          button_shadow #222222
          button_hilight #666666
          checkbox_text #888888
          checkbox_text_disabled #808080
          checkbox_fg #999999
          checkbox_inter #606060
          checkbox_bg #333333
          scrollbar #202020
          scrollbar_fg #999999
          scrollbar_bg #333333
          edit_cursor #0080ff
          edit_bg #222222
          edit_bg_disabled #666666
          edit_text #909090
          edit_text_disabled #808080
          edit_bg_sel #80c0ff
          edit_text_sel #80521f
          info_bk #333333
          info_text #BBBBBB
          menu_text_disabled #808080
          menu_scroll #404040
          menu_submenu_arrow #575757
          menubar_text_disabled #808080
          trackbar_track #303030
          trackbar_mark #606060
          trackbar_knob #808080
          progress #0080ff
          combo_bg #303030
          combo_bg2 #404040
          combo_shadow #222222
          combo_arrow #404040
          listview_bg #333333
          listview_bg_sel #666666
          listview_text #808080
          listview_hdr_arrow #606060
          treeview_text #909090
          treeview_bg #333333
          treeview_bg_sel #626262
          treeview_text_sel #999999
          treeview_arrow #404040
          tab_shadow #BFBFBF
          tab_hilight #808080
          tab_text #909090
          focusrect #ffffff
          group_text #909090
          focus_hilight #E6E6E6
        '';
        description = "Color theme to apply by adding libSwell.colortheme to config directory";
      };

      # Trying to get as close as possible to the original format
      # Based on research from here: https://mespotin.uber.space/Ultraschall/Reaper-Filetype-Descriptions.html#Reaper-kb.ini
      actions = let
        actionType = types.submodule {
          options = {
            name = mkOption {
              type = with types; nullOr str;
              default = null;
              description = ''
                Name of the action visible in REAPER.
                If not set, defaults to script path base name, then attribute name.
              '';
            };
            section = sectionOption;
            scriptPath = mkOption {
              type = with types; nullOr str;
              default = null;
              description = ''
                A path of the script to use through this action.
                The path should be relative to the Scripts directory in REAPER config directory.
              '';
            };
            actionIds = mkOption {
              type = with types; listOf (either int str);
              default = [];
              description = ''
                Component actions that this action consists of.
                Either builtin action id (int) or an action attribute name (string).
                Takes effect only when scriptPath is not set.
              '';
            };
            consolidateUndoPoints = mkOption {
              type = types.bool;
              default = false;
              description = "No effect if scriptPath is set.";
            };
            showInActionsMenu = mkOption {
              type = types.bool;
              default = false;
              description = "No effect if scriptPath is set.";
            };
            showActiveIfAllActive = mkOption {
              type = types.bool;
              default = true;
              description = ''
                Show action as active if all component actions are active.
                No effect if scriptPath is set.
              '';
            };
            includeIndeterminate = mkOption {
              type = types.bool;
              default = false;
              description = ''
                When showing action active state, indeterminate component actions count as active.
                No effect if scriptPath is set.
              '';
            };
          };
        };

        addAttrs = name: value:
          value
          // {
            attrName = name;
            commandId =
              if value.scriptPath == null
              then builtins.hashString "md5" name
              else "RS${builtins.hashString "sha1" value.scriptPath}";
            sectionId = toString sections.${value.section};
            description = "Custom: ${
              if (value.name != null)
              then value.name
              else if value.scriptPath != null
              then (baseNameOf (value.scriptPath))
              else name
            }";
            settingsMask = let
              toBit = condition:
                if condition
                then 1
                else 0;
              bitmask =
                (toBit value.consolidateUndoPoints)
                * 1
                + (toBit value.showInActionsMenu) * 2
                + (toBit (!value.showActiveIfAllActive)) * 16
                + (toBit (value.showActiveIfAllActive && value.includeIndeterminate)) * 32;
            in
              toString bitmask;
          };

        extraScriptsActions =
          mapAttrs (name: value: {
            name = value.name;
            section = value.section;
            scriptPath = getExtraScriptPath (
              if value.name == null
              then name
              else value.name
            );
          })
          config.programs.reaper.extraScripts;
      in
        mkOption {
          description = "Defined custom actions";
          default = {};
          type = types.attrsOf actionType;
          apply = v: mapAttrs addAttrs (v // extraScriptsActions);
        };

      shortcuts = let
        modifierOptions =
          genAttrs [
            "ctrl"
            "shift"
            "alt"
          ]
          (name: (mkOption {
            type = types.bool;
            default = false;
            description = "Set true if ${name} modifier is required for shortcut.";
          }));

        shortcutType = types.submodule {
          options = {
            type = mkOption {
              type = with types; enum ["key" "note" "cc" "pc"];
              default = "key";
              description = ''
                key: ASCII character corresponding to a key on a keyboard
                note: MIDI note number
                cc: MIDI continuous controller number
                pc: MIDI program change number
              '';
            };
            shortcut = mkOption {
              type = with types; either (ints.between 0 127) str;
              description = ''
                When the type is "key", this should be a string with a single character that can be typed with a keyboard.
                Letters should be capitalized.
                Otherwise a number for MIDI messages.
              '';
            };
            requiredModifiers = mkOption {
              type = types.submodule {options = modifierOptions;};
              description = ''Required modifiers when type is set to "key".'';
            };
            channel = mkOption {
              type = with types; (ints.between 1 16);
              default = 1;
              description = ''
                MIDI channel from 1 to 16. No effect if type is "key".
              '';
            };
            action = mkOption {
              type = with types; either int str;
              description = "Either builtin action id (int) or an action attribute name (string).";
            };
            section = sectionOption;
          };
        };

        modifierValues = {
          shift = 4;
          ctrl = 8;
          alt = 16;
        };

        getModifierSum = acc: name: value: (acc
          + ((
              if value
              then 1
              else 0
            )
            * modifierValues.${name}));

        addAttrs = value:
          value
          // {
            modifierString =
              if value.type == "key"
              then toString (1 + (foldlAttrs getModifierSum 0 value.requiredModifiers))
              else if value.type == "note"
              then toString (143 + value.channel)
              else if value.type == "cc"
              then toString (175 + value.channel)
              else if value.type == "pc"
              then toString (191 + value.channel)
              else abort "Invalid type of shortcut";

            shortcutString =
              if value.type == "key"
              then toString (charToInt value.shortcut)
              else toString value.shortcut;

            sectionId = toString sections.${value.section};
          };
      in
        mkOption {
          type = types.listOf shortcutType;
          default = [];
          description = "Defined shortcuts";
          apply = v: (map addAttrs v);
        };
    };

    config = let
      actionIdToString = value:
        if (types.int.check value)
        then (toString value)
        else "_" + cfg.actions.${value}.commandId;

      processedActions = mapAttrs (name: value:
        value
        // (
          if value.scriptPath == null
          then {actionIdsString = concatStringsSep " " (map actionIdToString value.actionIds);}
          else {}
        ))
      cfg.actions;

      processedShortcuts = map (value: value // {actionString = actionIdToString value.action;}) cfg.shortcuts;

      mkScriptLine = v: ''SCR 4 ${v.sectionId} ${v.commandId} "${v.description}" "${v.scriptPath}"'';
      mkCustomActionLine = v: ''ACT ${v.settingsMask} ${v.sectionId} "${v.commandId}" "${v.description}" ${v.actionIdsString}'';
      mkShortcutLine = v: ''KEY ${v.modifierString} ${v.shortcutString} ${v.actionString} ${v.sectionId}'';

      reaperKb = pkgs.writeTextDir "reaper-kb.ini" (concatLines (
        (map mkScriptLine (filter (v: v.scriptPath != null) (attrValues processedActions)))
        ++ (map mkCustomActionLine (filter (v: v.scriptPath == null) (attrValues processedActions)))
        ++ (map mkShortcutLine processedShortcuts)
      ));

      libSwellTheme = pkgs.writeTextDir "libSwell.colortheme" cfg.libSwellTheme;
      extraScripts = mapAttrsToList (name: value: (pkgs.writeTextDir "Scripts/${getExtraScriptPath name}" value.text)) cfg.extraScripts;
      extraJSFX = mapAttrsToList (name: value: (pkgs.writeTextDir "Effects/nix/${name}.jsfx" value)) cfg.extraJSFX;

      reaperConfigFiles =
        []
        ++ (optionals (cfg.actions != {} || cfg.shortcuts != []) [reaperKb])
        ++ cfg.reaPackPackages
        ++ extraScripts
        ++ extraJSFX
        ++ [libSwellTheme];
    in
      mkIf cfg.enable {
        home.packages = [cfg.package];
        xdg.configFile = {
          REAPER = {
            recursive = true;
            source = pkgs.symlinkJoin {
              name = "reaper-config-files";
              paths = reaperConfigFiles;
            };
          };
        };
      };
  }
