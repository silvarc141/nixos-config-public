{
  config,
  lib,
  ...
}: {
  imports = [./binds.nix];

  config = lib.mkIf config.programs.niri.enable {
    programs.niri.settings = [
      # kdl
      ''
        prefer-no-csd
        // hotkey-overlay { skip-at-startup }
        input {
          keyboard {
            xkb {
              layout "pl"
              options "ctrl:nocaps"
            }
          }
          touchpad {
            tap
            dwt
            natural-scroll
            click-method "clickfinger"
            disabled-on-external-mouse
          }
          mouse { accel-speed 1.0; }
        }
        cursor {
          hide-when-typing
          hide-after-inactive-ms 1000
        }
        output "eDP-1" {
          mode "1920x1080@144.003"
          scale 1.25
        }
        layout {
          focus-ring { off; }
          border {
            width 4
            active-color "#ffc87f"
            inactive-color "#505050"
          }
          gaps 4
          struts {
            top 0
            bottom 0
            left 32
            right 32
          }
        }
        screenshot-path "~/unsorted/screenshots/%Y-%m-%d_%H-%M-%S.png"
        animations { slowdown 0.8; }
        window-rule {
          geometry-corner-radius 15
          clip-to-geometry true
        }
      ''
    ];
  };
}
