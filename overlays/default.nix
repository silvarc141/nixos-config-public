{
  pkgsFinal,
  pkgsPrev,
  pkgsStable,
  pkgsUnstable,
  lib,
}: {
  # temp workaround: https://github.com/NixOS/nixpkgs/issues/248192
  xarchiver = pkgsPrev.xarchiver.overrideAttrs (prev: {
    postInstall = ''
      rm -rf $out/libexec
    '';
  });
  xfce = pkgsPrev.xfce.overrideScope (final: prev: {
    thunar-archive-plugin = prev.thunar-archive-plugin.overrideAttrs (_prev: {
      postInstall = ''
        cp ${pkgsPrev.xarchiver}/libexec/thunar-archive-plugin/* $out/libexec/thunar-archive-plugin/
      '';
    });
  });
  # wireplumber = pkgsPrev.wireplumber.overrideAttrs (old: {
  #   nativeBuildInputs = old.nativeBuildInputs ++ [pkgsFinal.makeWrapper];
  #   postInstall =
  #     (old.postInstall or "")
  #     + ''
  #       if [ -d scripts ]; then
  #         install -Dm644 scripts/*.lua -t $out/lib/lua/5.4/wireplumber/
  #       fi
  #     '';
  # });
}
