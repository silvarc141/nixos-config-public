{
  config,
  pkgs,
  lib,
  ...
}: {
  options.programs.unityhub.enable = lib.mkEnableOption "Unity game engine version hub";

  config = lib.mkIf config.programs.unityhub.enable {
    home.packages = with pkgs; [
      unityhub
    ];
    wayland.windowManager.hyprland = lib.mkIf config.wayland.windowManager.hyprland.enable {
      settings = {
        windowrulev2 = [
          # default
          "tile, initialClass:^(Unity)$"

          # tooltips
          "float, initialClass:^(Unity)$, initialTitle:^(UnityTooltipWindow)$"
          "nofocus, initialClass:^(Unity)$, initialTitle:^(UnityTooltipWindow)$"

          # dropdowns and loading banner
          "float, initialClass:^(Unity)$, initialTitle:^(Unity)$"
          "float, initialClass:^(Unity)$, initialTitle:^(Sirenix.*)$" # for odin dropdowns

          # main window
          "workspace 1 silent, initialClass:^(Unity)$, initialTitle:^(Unity - Unity .*Vulkan.*)$"

          # undocked windows
          "workspace 1 silent, initialClass:^(Unity)$, initialTitle:^()$"
        ];
      };
    };
    custom.ephemeral = {
      data = {
        directories = [
          ".config/unity3d"
          ".config/unityhub"
        ];
      };
      cache = {
        directories = [
          ".npm"
          ".local/share/IsolatedStorage/"
        ];
      };
      large = {
        directories = [
          ".local/share/unityhub/editors"
        ];
      };
    };
    home.activation = lib.mkIf config.custom.ephemeral.enable {
      unitySetupFix = lib.hm.dag.entryAfter ["writeBoundary"] ''
        mkdir -p /persist/home/${config.home.username}/large/.local/share/unityhub/editors
      '';
    };
    # very experimental
    # xdg.configFile = {
    #   "unityhub/themeSetting.json".text = builtins.toJSON {themeSource = "dark";};
    #   "unityhub/surveySettings.json".text = builtins.toJSON {uscSurveyCountdown = 2;};
    #   "unityhub/skipRemoveConfirmation.json".text = builtins.toJSON {
    #     timestamp = 0;
    #     always = true;
    #   };
    #   "unityhub/hideHubOnEditorOpen.json".text = "true";
    #   "unityhub/firstTimeOpenKey.json".text = "false";
    #   "unityhub/firstTimeSettings.json".text = builtins.toJSON {
    #     showLicenseProvisioning = false;
    #     showEditorRecommendation = false;
    #     showWelcomeModal = false;
    #     showLearnTemplates = true;
    #     showPersonalLicenseEulaFirstTimeModal = false;
    #   };
    #   "unityhub/projectDir.json".text = builtins.toJSON {directoryPath = "/home/silvarc/projects";};
    #   "unityhub/secondaryInstallPath.json".text = builtins.toJSON { directoryPath = "/home/silvarc/.local/share/unityhub/editors"; };
    # };
  };
}
