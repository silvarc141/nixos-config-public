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
          "float, class:^(Unity)$, title:^(Unity)$"
          #"workspace special:unity silent, class:^(Unity)$, title:^(.*Unity.*)$"
        ];
      };
    };
    xdg.configFile = {
      "unityhub/themeSetting.json".text = builtins.toJSON {themeSource = "dark";};
      "unityhub/surveySettings.json".text = builtins.toJSON {uscSurveyCountdown = 2;};
      "unityhub/skipRemoveConfirmation.json".text = builtins.toJSON {
        timestamp = 0;
        always = true;
      };
      "unityhub/hideHubOnEditorOpen.json".text = "true";
      "unityhub/firstTimeOpenKey.json".text = "false";
      "unityhub/firstTimeSettings.json".text = builtins.toJSON {
        showLicenseProvisioning = false;
        showEditorRecommendation = false;
        showWelcomeModal = false;
        showLearnTemplates = true;
        showPersonalLicenseEulaFirstTimeModal = false;
      };
      "unityhub/projectDir.json".text = builtins.toJSON {directoryPath = "/home/silvarc/projects";};
      # "unityhub/secondaryInstallPath.json".text = builtins.toJSON { directoryPath = "/home/silvarc/.local/share/unityhub/editors"; };
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
        ];
      };
      large = {
        directories = [
          ".local/share/unityhub/editors"
        ];
      };
    };
  };
}
