{
  lib,
  config,
  pkgs,
  ...
}: {
  custom = {
    disko = {
      enable = true;
      deviceName = "/dev/nvme0n1";
      swapSize = "36G";
    };
    boot = {
      enable = true;
      fullDiskEncryption = {
        enable = true;
        unattendedDecryption.enable = true;
      };
      hibernation = {
        enable = true;
        offset = 15094085;
        # offset = 533760; # change to this on fresh install, above is temp
      };
      secureBoot.enable = true;
    };
    tty.enable = true;
    bluetooth.enable = true;
    audio.enable = true;
    usb.enable = true;
    lid.enable = true;
    printing.enable = true;
    ephemeral.enable = true;
    mainUser = {
      hasSecretsAccess = true;
      homeType = "workstation";
    };
    graphical = {
      enable = true;
      gaming.enable = true;
      virtualReality.enable = true;
      virtualization.enable = true;
      windowManager = "hyprland";
    };
    workstation = {
      audio.enable = true;
      unity.enable = true;
      sambaMount.enable = true;
      configSymlink.enable = true;
    };
  };
  environment.systemPackages = with pkgs; [
    nvtopPackages.nvidia
    nvtopPackages.amd
    libva-utils
  ];
  environment.variables = lib.mkIf config.custom.graphical.wayland.enable {
    # video acceleration on integrated amdgpu
    LIBVA_DRIVER_NAME = "radeonsi";

    # required for nvidia on wayland
    GBM_BACKEND = "nvidia-drm";

    # make sure to not run nouveau
    GLX_VENDOR_LIBRARY_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };
  boot = {
    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod"];
      kernelModules = ["dm-snapshot"];
    };
    kernelModules = ["kvm-amd"];
  };

  # Unneeded for now
  # older kernel -> older nvidia drivers -> working cuda
  # nixpkgs.overlays = [
  #   (final: prev: {
  #     linuxPackages =
  #       (import (prev.fetchFromGitHub {
  #           owner = "nixos";
  #           repo = "nixpkgs";
  #           rev = "5135c59491985879812717f4c9fea69604e7f26f";
  #           sha256 = "sha256-Vr3Qi346M+8CjedtbyUevIGDZW8LcA1fTG0ugPY/Hic=";
  #         }) {
  #           system = prev.system;
  #           config = {allowUnfree = true;};
  #         })
  #       .linuxPackages;
  #   })
  # ];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = "x86_64-linux";
  services.xserver.videoDrivers = ["nvidia"];
  hardware = {
    cpu.amd.updateMicrocode = true;
    nvidia = {
      modesetting.enable = true;
      open = true;
      videoAcceleration = false;
      nvidiaSettings = true;
      prime = {
        sync.enable = true;
        nvidiaBusId = "PCI:1:0:0";
        amdgpuBusId = "PCI:5:0:0";
      };
      package = config.boot.kernelPackages.nvidiaPackages.production;
    };
  };
  programs.gamescope.args = ["-F nis"];
  services.pipewire.wireplumber = {
    extraScripts = {
      "copy-to-bluetooth-sinks.lua" =
        # lua
        ''
          -- Log package search paths
          Log.info("=== Lua Module Search Paths ===")
          Log.info("package.path = " .. (package.path or "(nil)"))
          Log.info("package.cpath = " .. (package.cpath or "(nil)"))

          -- Try loading a known module
          local success, result = pcall(require, "wireplumber.ObjectManager")
          if success then
            Log.info("Successfully required wireplumber.ObjectManager")
          else
            Log.warning("Failed to require wireplumber.ObjectManager: " .. result)
          end

          -- Optionally list available files in the Lua path (sandbox may restrict this)
          local lfs = require("lfs")
          local paths = {}
          for path in string.gmatch(package.path or "", "([^;]+)") do
            local dir = string.gsub(path, "/%?%.lua", "")
            table.insert(paths, dir)
          end

          for _, dir in ipairs(paths) do
            Log.info("Checking path: " .. dir)
            local ok, iter = pcall(lfs.dir, dir)
            if ok then
              for file in iter do
                if file ~= "." and file ~= ".." then
                  Log.info("  Found: " .. file)
                end
              end
            else
              Log.warning("  Could not read directory: " .. dir)
            end
          end
        '';
    };
    extraConfig = {
      # "log-level-debug" = {
      #   "context.properties" = {
      #     "log.level" = "D";
      #   };
      # };

      # copy-to-bluetooth-sinks = {
      #   "wireplumber.components" = [
      #     {
      #       name = "copy-to-bluetooth-sinks.lua";
      #       type = "script/lua";
      #       provides = "custom.copy-to-bluetooth-sinks";
      #     }
      #   ];
      #   "wireplumber.profiles" = {
      #     main."custom.copy-to-bluetooth-sinks" = "required";
      #   };
      # };
      #
      # copy-to-bluetooth-sinks-v2 = {
      #   "monitor.alsa.rules" = [
      #     {
      #       matches = [
      #         {"media.class" = "Stream/Output";}
      #       ];
      #       actions = {
      #         update-props = {
      #           "audio.duplicate-to" = "bluez_output.*"; # uses glob match to all BT sinks
      #         };
      #       };
      #     }
      #   ];
      # };

      mic-deep-noise-remover = {
        "wireplumber.profiles" = {
          main = {
            "node.software-dsp" = "required";
          };
        };
        "node.software-dsp.rules" = [
          {
            matches = [
              {
                "api.alsa.path" = "front:2";
                "api.alsa.pcm.stream" = "capture";
              }
            ];
            actions = {
              create-filter = {
                filter-path = pkgs.writeText "deep-noise-remover-graph.json" (builtins.toJSON
                  {
                    "node.description" = "Denoised Mic";
                    "media.name" = "Denoised Mic";
                    "filter.graph" = {
                      "nodes" = [
                        {
                          "type" = "ladspa";
                          "label" = "deep_filter_mono";
                          "name" = "DeepFilter Mono";
                          "plugin" = "${pkgs.deepfilternet}/lib/ladspa/libdeep_filter_ladspa.so";
                          "control" = {
                            "Attenuation Limit (dB)" = 100;
                          };
                        }
                      ];
                    };
                    "capture.props" = {
                      "node.name" = "capture.denoised-mic";
                      "node.passive" = "true";
                      "target.object" = "alsa_input.pci-0000_05_00.6.analog-stereo";
                      "node.virtual" = "false";
                      # "node.dont-fallback" = "true";
                    };
                    "playback.props" = {
                      "node.name" = "denoised-mic";
                      "media.class" = "Audio/Source";
                      "node.virtual" = "false";
                    };
                  });
                # hide-parent = true;
              };
            };
          }
        ];
      };
    };
  };
}
