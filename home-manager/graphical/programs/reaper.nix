{
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf config.programs.reaper.enable {
    home.packages = with pkgs; [
      # to test
      sfizz # sfz player
      drumgizmo # drum synthesis
      chow-kick # drum synthesis
      geonkick # drum synthesis
      polyphone # for sf2 creation
    ];

    custom.ephemeral.data = {
      directories = [".config/REAPER"];
    };

    programs.reaper = {
      extraScripts = {
        testExtraScript.text =
          #lua
          ''
            reaper.ShowMessageBox("test message", "test", 0)
          '';
      };
      extraJSFX = {
        testJSFX = ''
          test
        '';
      };
      actions = {
        global-sampler.scriptPath = "BirdBird ReaScript Testing/Global Sampler/BirdBird_Global Sampler.lua";
        testScript = {
          scriptPath = "X-Raym Scripts/Color/X-Raym_Display color of selected tracks items and takes in the console.eel";
        };
        testCustomAction = {
          consolidateUndoPoints = true;
          showActiveIfAllActive = false;
          actionIds = [2019];
        };
      };
      shortcuts = [
        {
          shortcut = "A";
          requiredModifiers.ctrl = true;
          action = 2019;
        }
        {
          shortcut = "B";
          requiredModifiers = {
            ctrl = true;
            alt = true;
            shift = true;
          };
          action = "testScript";
        }
        {
          shortcut = "A";
          requiredModifiers = {
            ctrl = true;
            alt = true;
          };
          action = "testCustomAction";
        }
      ];
      # reaPackPackages = let
      #   known = inputs.reapkgs-known.packages.${pkgs.system};
      #   extended = inputs.reapkgs-extended.packages.${pkgs.system};
      # in [
      #   extended.reaper-keys.install-reaper-keys-lua-2-0-0-a7
      #   extended.birdbird-reascript-testing.birdbird-global-sampler-lua-0-99-8-4
      # ];
      # ++ (with known.reateam-extensions; [
      #   reaper-oss-sws-ext-2-14-0-3
      #   js-reascriptapi-ext-1-310
      # ])
      # ++ (with known.x-raym-scripts; [
      #   x-raym-display-color-of-selected-tracks-items-and-takes-in-the-console-eel-1-0
      #   x-raym-select-items-with-same-color-as-mouse-context-or-first-selected-item-on-selected-tracks-lua-1-1
      #   x-raym-move-edit-cursor-to-next-frame-lua-1-0
      # ]);
      # build failing (hash empty)
      # ++ (with known.saike-tools; [
      #   saike-yutani-jsfx-0-101
      #   squashman-jsfx-0-85
      #   saike-abyss-jsfx-0-05
      # ])
    };
    wayland.windowManager.hyprland = lib.mkIf config.wayland.windowManager.hyprland.enable {
      settings = {
        windowrulev2 = [
          # defaults
          "tile, class:^(REAPER)$"
          "workspace 6 silent, initialClass:^(.*REAPER.*)$"

          # tooltips
          "nofocus, floating:1, class:^(REAPER)$, title:^()$"
          "norounding, floating:1, class:^(REAPER)$, title:^()$"
          "noanim, floating:1, class:^(REAPER)$, title:^()$"

          # dropdowns
          "float, class:^(REAPER)$, title:^(menu)$"
          "norounding, class:^(REAPER)$, title:^(menu)$"
          "noanim, class:^(REAPER)$, title:^(menu)$"

          # MIDI
          "workspace 7 silent, class:^(REAPER)$ initialTitle:^(Edit MIDI)$"

          # plugins
          "pseudo, class:^(REAPER)$ initialTitle:^(VST.*)$"
          "workspace 8 silent, class:^(REAPER)$ initialTitle:^(VST.*)$"

          # hide annoyances
          "workspace special:trash silent, class:^(REAPER)$, title:^(.*About REAPER.*)$"
          "workspace special:trash silent, class:^(REAPER)$, title:^(REAPER New Version Notification)$"
          "workspace special:trash silent, class:^(REAPER)$, title:^(REAPER .*initializing.*)$"
        ];
      };
    };
  };
}
