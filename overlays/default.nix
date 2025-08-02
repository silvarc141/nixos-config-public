{
  inputs,
  final,
  prev,
  stable,
  unstable,
}: {
  # https://github.com/NixOS/nixpkgs/issues/248192
  xarchiver = prev.xarchiver.overrideAttrs (prev: {
    postInstall = ''
      rm -rf $out/libexec
    '';
  });
  xfce = prev.xfce.overrideScope (finalInScope: prevInScope: {
    thunar-archive-plugin = prevInScope.thunar-archive-plugin.overrideAttrs (prevInOverride: {
      postInstall = ''
        cp ${prev.xarchiver}/libexec/thunar-archive-plugin/* $out/libexec/thunar-archive-plugin/
      '';
    });
  });
  # https://github.com/nix-community/home-manager/issues/7517
  nushell = unstable.nushell;
  wf-touch = final.callPackage "${inputs.hyprgrass}/nix/wf-touch.nix" {};
  hyprgrass = final.callPackage "${inputs.hyprgrass}/nix/default.nix" {
    hyprlandPlugins = final.hyprlandPlugins;
    wf-touch = final.wf-touch;
    tag = "0.8.2";
    commit = inputs.hyprgrass.rev;
    hyprland = final.hyprland;
  };
}
