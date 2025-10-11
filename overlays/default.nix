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
  carapace = unstable.carapace;

  jetbrains.rider = unstable.jetbrains.rider;

  reaper = prev.reaper.overrideAttrs (oldAttrs: {
    postFixup = ''
      wrapProgram $out/bin/reaper --unset GDK_BACKEND
    '';
  });
}
