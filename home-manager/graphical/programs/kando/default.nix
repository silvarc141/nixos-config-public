{
  lib,
  config,
  ...
}: {
  imports = [./menus.nix];

  config = lib.mkIf config.programs.kando.enable {
    programs.kando = {
      settings = {
        locale = "auto";
        menuTheme = "rainbow-labels";
        darkMenuTheme = "default";
        menuThemeColors = {};
        darkMenuThemeColors = {};
        enableDarkModeForMenuThemes = false;
        soundTheme = "none";
        soundVolume = 0.5;
        sidebarVisible = false;
        ignoreWriteProtectedConfigFiles = true;
        trayIconFlavor = "white";
        enableVersionCheck = false;
        zoomFactor = 1;
        menuOptions = {
          centerDeadZone = 50;
          minParentDistance = 150;
          dragThreshold = 15;
          fadeInDuration = 50;
          fadeOutDuration = 50;
          enableMarkingMode = true;
          enableTurboMode = true;
          hoverModeNeedsConfirmation = true;
          gestureMinStrokeLength = 150;
          gestureMinStrokeAngle = 20;
          gestureJitterThreshold = 5;
          gesturePauseTimeout = 50;
          fixedStrokeLength = 0;
          rmbSelectsParent = false;
          gamepadBackButton = 1;
          gamepadCloseButton = 2;
        };
        editorOptions = {
          showSidebarButtonVisible = false;
          showEditorButtonVisible = false;
        };
      };
    };
    custom.ephemeral.data = {
      directories = [".config/kando/session"];
      # files = [".config/kando/config.json"];
    };
    wayland.windowManager.hyprland = lib.mkIf config.wayland.windowManager.hyprland.enable {
      settings = {
        bindp = [
          "SUPER, Tab, global, kando:main"
          "SUPER, mouse:272, global, kando:main"
        ];
        windowrulev2 = [
          "noblur, class:^(kando)$"
          "opaque, class:^(kando)$"
          "size 100% 100%, class:^(kando)$"
          "noborder, class:^(kando)$"
          "noanim, class:^(kando)$"
          "float, class:^(kando)$"
          "pin, class:^(kando)$"
          "dimaround, class:^(kando)$"
        ];
      };
    };
  };
}
