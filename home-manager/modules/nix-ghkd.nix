{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) types mkIf mkEnableOption mkOption unique concatMap listToAttrs mapAttrsToList escapeShellArg;
  cfg = config.services.nix-ghkd;
in {
  options.services.nix-ghkd = {
    enable = mkEnableOption "nix-ghkd: nix gamepad hotkey daemon";
    devices = mkOption {
      type = types.attrsOf (types.submodule ({...}: {
        options = {
          enable = mkEnableOption "this specific gamepad configuration";
          devicePath = mkOption {type = types.str;};
          buttons = mkOption {
            type = types.listOf (types.submodule ({...}: {
              options = {
                buttonCode = mkOption {type = types.int;};
                command = mkOption {type = types.str;};
                packages = mkOption {
                  type = types.listOf types.package;
                  default = [];
                };
              };
            }));
            default = [];
          };
        };
      }));
      default = {};
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services = listToAttrs (mapAttrsToList (name: deviceCfg: {
        name = "nix-ghkd-${name}";
        value = mkIf deviceCfg.enable {
          Unit = {
            Description = "Gamepad hotkey daemon for ${name}";
          };
          Install = {
            WantedBy = ["graphical-session.target"];
          };
          Service = {
            path = (unique (concatMap (b: b.packages) deviceCfg.buttons)) ++ [pkgs.coreutils];
            ExecStart = let
              buttonMapJson = builtins.toJSON (listToAttrs (
                map
                (b: {
                  name = toString b.buttonCode;
                  value = {command = b.command;};
                })
                deviceCfg.buttons
              ));

              pythonScript =
                pkgs.writeText "nix-ghkd-logic.py"
                # py
                ''
                  import evdev, subprocess, asyncio, sys, json

                  BUTTON_MAPPINGS = json.loads(sys.argv[1])
                  DEVICE_PATH = sys.argv[2]
                  DEVICE_NAME = sys.argv[3]

                  async def main():
                      print(f"Starting nix-ghkd for {DEVICE_NAME} with {len(BUTTON_MAPPINGS)} button(s) configured.")
                      try:
                          device = evdev.InputDevice(DEVICE_PATH)
                      except Exception as e:
                          print(f"[nix-ghkd] Error opening device for {DEVICE_NAME}: {e}", file=sys.stderr)
                          sys.exit(1)

                      async for event in device.async_read_loop():
                          if event.type == evdev.ecodes.EV_KEY and event.value == 1:
                              key = str(event.code)
                              if key in BUTTON_MAPPINGS:
                                  command_to_run = BUTTON_MAPPINGS[key]["command"]
                                  print(f"[nix-ghkd] Button {key} on {DEVICE_NAME} -> running: {command_to_run}")
                                  subprocess.run(command_to_run, shell=True)

                  if __name__ == "__main__":
                      asyncio.run(main())
                '';

              wrapper = pkgs.writeShellApplication {
                name = "nix-ghkd-${name}";
                runtimeInputs = [(pkgs.python3.withPackages (ps: [ps.evdev]))];
                text = ''
                  exec python3 ${pythonScript} "$@"
                '';
              };
            in ''
              ${wrapper}/bin/nix-ghkd-${name} \
                ${escapeShellArg buttonMapJson} \
                ${escapeShellArg deviceCfg.devicePath} \
                ${escapeShellArg name}
            '';
            Restart = "on-failure";
            RestartSec = "5s";
          };
        };
      })
      cfg.devices);
  };
}
