{
  inputs,
  overlays,
  ...
}: {
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
    overlays = overlays;
  };

  nix = {
    channel.enable = false;
    registry = {
      np.flake = inputs.nixpkgs-stable;
      npu.flake = inputs.nixpkgs-unstable;
    };
    settings = {
      trusted-users = ["@wheel" "root"];
      experimental-features = ["nix-command" "flakes"];
      warn-dirty = false;
      substituters = [
        "https://cache.nixos.org/"
        # "https://nix-community.cachix.org"
        # "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [
        "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
        # "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        # "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
}
