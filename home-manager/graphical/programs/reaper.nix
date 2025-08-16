{
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf config.programs.reaper.enable {
    home.packages = with pkgs; [sfizz];

    custom.ephemeral = {
      data = {
        directories = [
          ".config/REAPER"
          ".local/share/reaper/unsaved-recording"
          ".local/share/reaper/backup-auto"
          ".local/share/reaper/backup-unsaved"
        ];
      };
      cache = {
        directories = [
          ".local/share/reaper/peaks"
        ];
      };
    };

    xdg.desktopEntries.cockos-reaper = {
      name = "REAPER";
      type = "Application";
      exec = "${pkgs.reaper}/bin/reaper";
      icon = "cockos-reaper";
      noDisplay = false;
      categories = [
        "Audio"
        "Video"
        "AudioVideo"
        "AudioVideoEditing"
        "Recorder"
      ];
      mimeType = [
        "application/x-reaper-project"
        "application/x-reaper-project-backup"
        "application/x-reaper-theme"
      ];
      settings = {
        StartupWMClass = "REAPER";
      };
    };

    programs.reaper = {
      settings = {
        reaper = {
          altpeaks = "5";
          altpeakspath = "/home/silvarc/.local/share/reaper/peaks/";

          autosaveint = "5";
          autosavedir = "/home/silvarc/.local/share/reaper/backup-auto/";
          autosavedir_unsaved = "/home/silvarc/.local/share/reaper/backup-unsaved/";

          deffadelen = "0.00000000";
          # defsplitxfadelen="0.00000000";

          defrecpath = "/home/silvarc/.local/share/reaper/unsaved-recording/";
          defsavepath = "/home/silvarc/media/projects-audio/";

          lv2path_linux = "/usr/lib/lv2;/usr/local/lib/lv2;~/.lv2;~/.nix-profile/lib/lv2;";
          vstpath = "~/.vst;~/.vst3;~/.nix-profile/lib/vst3;~/.nix-profile/lib/vst;";
          clap_path_linux-x86_64 = "/usr/local/lib/clap;/usr/lib/clap;~/.clap;%CLAP_PATH%;~/.nix-profile/lib/clap";

          loopnewitems = "32";
          loadlastproj = "19";

          mixwnd_vis = "0";
          transport_dock_pos = "3";
          transflags = "8";

          multiprojopt = "128";
        };
      };
      # extraScripts = {
      #   testExtraScript.text =
      #     #lua
      #     ''
      #       reaper.ShowMessageBox("test message", "test", 0)
      #     '';
      # };
      # extraJSFX = {
      #   testJSFX = ''
      #     test
      #   '';
      # };
      # actions = {
      #   global-sampler.scriptPath = "BirdBird ReaScript Testing/Global Sampler/BirdBird_Global Sampler.lua";
      #   testScript = {
      #     scriptPath = "X-Raym Scripts/Color/X-Raym_Display color of selected tracks items and takes in the console.eel";
      #   };
      #   testCustomAction = {
      #     consolidateUndoPoints = true;
      #     showActiveIfAllActive = false;
      #     actionIds = [2019];
      #   };
      # };
      # shortcuts = [
      #   {
      #     shortcut = "A";
      #     requiredModifiers.ctrl = true;
      #     action = 2019;
      #   }
      #   {
      #     shortcut = "B";
      #     requiredModifiers = {
      #       ctrl = true;
      #       alt = true;
      #       shift = true;
      #     };
      #     action = "testScript";
      #   }
      #   {
      #     shortcut = "A";
      #     requiredModifiers = {
      #       ctrl = true;
      #       alt = true;
      #     };
      #     action = "testCustomAction";
      #   }
      # ];
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

          # tooltips
          "nofocus, floating:1, class:^(REAPER)$, title:^()$"
          "norounding, floating:1, class:^(REAPER)$, title:^()$"
          "noanim, floating:1, class:^(REAPER)$, title:^()$"

          # dropdowns
          "float, class:^(REAPER)$, title:^(menu)$"
          "norounding, class:^(REAPER)$, title:^(menu)$"
          "noanim, class:^(REAPER)$, title:^(menu)$"

          # main window
          "workspace 1 silent, class:^(REAPER)$ initialTitle:^(REAPER v.*)$"

          # MIDI
          "workspace 2 silent, class:^(REAPER)$ initialTitle:^(Edit MIDI)$"

          # plugins
          "workspace 3 silent, class:^(REAPER)$ initialTitle:^(FX:.*)$"

          # hide annoyances
          "workspace special:trash silent, class:^(REAPER)$, title:^(.*About REAPER.*)$"
          "workspace special:trash silent, class:^(REAPER)$, title:^(REAPER New Version Notification)$"
          "workspace special:trash silent, class:^(REAPER)$, title:^(REAPER .*initializing.*)$"
        ];
      };
    };
  };
}
