{
  config,
  lib,
  ...
}: {
  options.programs.nixvim.custom.actionPickerLayers = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule {
      options = {
        name = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Optional custom name for this action picker layer. If not set, the attribute name will be used.";
        };
        icon = lib.mkOption {
          type = lib.types.str;
          description = "Icon for this action picker layer";
        };
        leader = lib.mkOption {
          type = lib.types.str;
          default = "<leader>";
          description = "Leader key for this action picker layer";
        };
        mode = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = ["n" "v" "o"];
          description = "List of modes for all mappings in this layer (e.g., [\"n\" \"v\"])";
        };
        prefix = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Prefix to be added before all actions in this layer";
        };
        suffix = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Suffix to be added after all actions in this layer";
        };
        isLua = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether all actions in this layer are Lua code";
        };
        actions = lib.mkOption {
          type = lib.types.attrsOf (lib.types.submodule {
            options = {
              description = lib.mkOption {
                type = lib.types.str;
                description = "Description of the action";
              };
              action = lib.mkOption {
                type = lib.types.str;
                description = "The action to be executed";
              };
              isLua = lib.mkOption {
                type = lib.types.nullOr lib.types.bool;
                default = null;
                description = "Whether this action is Lua code. If null, uses the layer's isLua setting.";
              };
            };
          });
          description = "Set of actions in this picker map";
        };
      };
    });
    default = {};
    description = "List of action picker maps, each representing a layer of actions";
  };

  config = let
    mkKeymap = {
      layer,
      key,
      actionConfig,
    }: {
      mode = layer.mode;
      key = layer.leader + key;
      action =
        if
          (
            if (actionConfig.isLua != null)
            then actionConfig.isLua
            else layer.isLua
          )
        then config.lib.nixvim.mkRaw "function() ${layer.prefix + actionConfig.action + layer.suffix} end"
        else (layer.prefix + actionConfig.action + layer.suffix);
      options.desc = actionConfig.description;
    };

    mkLayerKeymaps = name: layer: lib.mapAttrsToList (key: actionConfig: mkKeymap {inherit layer key actionConfig;}) layer.actions;

    mkLayerLeaderWhichKeySpec = name: layer: {
      __unkeyed-1 = layer.leader;
      group =
        if (layer.name != null)
        then layer.name
        else name;
      icon = layer.icon;
      mode = layer.mode;
    };

    mkLayerLeaderWhichKeyTrigger = name: layer: {
      __unkeyed-1 = layer.leader;
      mode = lib.strings.concatStrings layer.mode;
    };

    mkLayerLeaderUnmapKeymap = name: layer: {
      mode = layer.mode;
      key = layer.leader;
      action = "<Nop>";
    };

    layers = config.programs.nixvim.custom.actionPickerLayers;
    allLayerActionKeymaps = lib.flatten (lib.mapAttrsToList mkLayerKeymaps layers);
    leaderWhichKeySpec = lib.mapAttrsToList mkLayerLeaderWhichKeySpec layers;

    # make sure layer leaders that are not deemed "unsafe" by which-key are no-ops but their descriptions are triggered
    whichKeySafeMaps = ["<leader>" "g" "z"];
    layersWithUnsafeLeaders = lib.filterAttrs (name: layer: !(builtins.any (prefix: lib.hasPrefix prefix layer.leader) whichKeySafeMaps)) layers;
    leaderWhichKeyTriggers = lib.mapAttrsToList mkLayerLeaderWhichKeyTrigger layersWithUnsafeLeaders;
    leaderUnmapKeymaps = lib.mapAttrsToList mkLayerLeaderUnmapKeymap layersWithUnsafeLeaders;
  in
    lib.mkIf config.custom.nixvim.enable {
      programs.nixvim = {
        plugins.which-key.settings = {
          spec = leaderWhichKeySpec;
          triggers =
            # retain default "safe" key triggers
            [
              {
                __unkeyed-1 = "<auto>";
                mode = "nxsot";
              }
            ]
            ++ leaderWhichKeyTriggers;
        };
        keymaps = allLayerActionKeymaps ++ leaderUnmapKeymaps;
      };
    };
}
