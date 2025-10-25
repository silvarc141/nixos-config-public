{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  makeWrapper,
  buildFHSEnv,
  extraPkgs ? pkgs: [],
  extraLibs ? pkgs: [],
}:
stdenv.mkDerivation rec {
  pname = "plastic-scm";
  version = "11.0.16.8786";

  srcs = [
    (fetchurl {
      url = "https://www.plasticscm.com/plasticrepo/stable/debian/amd64/plasticscm-complete_${version}_amd64.deb";
      sha256 = "102128abc0175f1038241f7e5f89e941715c87f6df5d4c1809fccfd328e4c084";
    })
    (fetchurl {
      url = "https://www.plasticscm.com/plasticrepo/stable/debian/amd64/plasticscm-client-complete_${version}_amd64.deb";
      sha256 = "03a15613c0ec3cd96d884e56ade234896c7391959ba66185c2d0e84c94d3552a";
    })
    (fetchurl {
      url = "https://www.plasticscm.com/plasticrepo/stable/debian/amd64/plasticscm-client-core_${version}_amd64.deb";
      sha256 = "4f24357ca1f98c98877b7d8f57f90e616bf55569d13646392ae2e8d32e143d99";
    })
    (fetchurl {
      url = "https://www.plasticscm.com/plasticrepo/stable/debian/amd64/plasticscm-client-gui_${version}_amd64.deb";
      sha256 = "89e70d89364366b6710d9536a0a1df91aefe78f696053d72556d07254c5dfe3a";
    })
    (fetchurl {
      url = "https://www.plasticscm.com/plasticrepo/stable/debian/amd64/plasticscm-server-core_${version}_amd64.deb";
      sha256 = "afca8abcee63358ced0b2c64566e9e14edbda4566303a3ece0c7dc7ebc86fc56";
    })
    (fetchurl {
      url = "https://www.plasticscm.com/plasticrepo/stable/debian/amd64/plasticscm-theme_${version}_amd64.deb";
      sha256 = "4d4fe9f8da559f9f448532ff9155319b5951ffe73bd0355b319d978f018f408f";
    })
    (fetchurl {
      url = "https://www.plasticscm.com/plasticrepo/stable/debian/amd64/plasticscm-certtools-mono4_3.12.1_amd64.deb";
      sha256 = "9e8ddd7cbec573cb12e2d00575a40f88e6c57346aac6059413aab3da846f70ab";
    })
    (fetchurl {
      url = "https://www.plasticscm.com/plasticrepo/stable/debian/amd64/plasticscm-gnome-sharp-mono4_2.24.0_amd64.deb";
      sha256 = "338fbede92a8ff75fc7cc51ddb8b8bcbe25e447bdf0b3b9c99b905ef64fed9bf";
    })
    (fetchurl {
      url = "https://www.plasticscm.com/plasticrepo/stable/debian/amd64/plasticscm-gtk-sharp-mono4_2.12.29_amd64.deb";
      sha256 = "f6620e122dee594a284315eb864bce6ea2c9c52c57e2f69d25c92c90e16176c2";
    })
    (fetchurl {
      url = "https://www.plasticscm.com/plasticrepo/stable/debian/amd64/plasticscm-mono4_4.6.2_amd64.deb";
      sha256 = "c2a56507be32e5b365067934ff0077d52962604d7467e37acba2b98d3e931f36";
    })
  ];

  nativeBuildInputs = [
    dpkg
    makeWrapper
  ];

  fhsEnv = buildFHSEnv {
    name = "${pname}-fhs-env";
    runScript = "";

    targetPkgs = pkgs: extraPkgs pkgs;

    multiPkgs = pkgs:
      with pkgs;
        [
          # Plastic dpkg dependencies
          gcc14
          libcxx
          zlib
          krb5
          lttng-ust
          openssl
          icu74
          keyutils

          # Plastic GUI dependencies
          xorg.libX11
          xorg.libICE
          xorg.libSM
          gtk3
          dbus

          #verify is needed
          #gnome2.libgnomeui

          # SkiaSharp ldd dependencies
          fontconfig
        ]
        ++ extraLibs pkgs;
  };

  unpackCmd = "dpkg -x $curSrc src";

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mv opt/ usr/share/ etc/ var/ $out

    makeWrapper ${fhsEnv}/bin/${pname}-fhs-env $out/wrappers/cm \
      --add-flags $out/opt/plasticscm5/client/cm \
      --argv0 cm

    makeWrapper ${fhsEnv}/bin/${pname}-fhs-env $out/wrappers/gluon \
      --add-flags $out/opt/plasticscm5/client/lingluonx \
      --argv0 gluon

    makeWrapper ${fhsEnv}/bin/${pname}-fhs-env $out/wrappers/plasticgui \
      --add-flags $out/opt/plasticscm5/client/linplasticx \
      --argv0 plasticgui

    makeWrapper ${fhsEnv}/bin/${pname}-fhs-env $out/wrappers/semanticmergetool \
      --add-flags $out/opt/plasticscm5/client/semanticmergetool \
      --argv0 semanticmergetool

    makeWrapper ${fhsEnv}/bin/${pname}-fhs-env $out/wrappers/gtkmergetool \
      --add-flags $out/opt/plasticscm5/client/gtkmergetool \
      --argv0 gtkmergetool

    makeWrapper ${fhsEnv}/bin/${pname}-fhs-env $out/wrappers/plasticd \
      --add-flags $out/opt/plasticscm5/server/plasticd \
      --argv0 plasticd

    mkdir -p $out/bin
    ln -s $out/wrappers/cm $out/bin/cm
    ln -s $out/wrappers/gluon $out/bin/gluon
    ln -s $out/wrappers/plasticgui $out/bin/plasticgui
    ln -s $out/wrappers/semanticmergetool $out/bin/semanticmergetool
    ln -s $out/wrappers/gtkmergetool $out/bin/gtkmergetool
    ln -s $out/wrappers/plasticd $out/bin/plasticd

    # Replace absolute path in desktop file to correctly point to nix store
    substituteInPlace $out/share/applications/unityvcs.desktop \
      --replace /opt/plasticscm5/client/linplasticx $out/wrappers/plasticgui
    substituteInPlace $out/share/applications/unityvcs.desktop \
      --replace /opt/plasticscm5/theme/avalonia/icons/linunityvcs.ico $out/opt/plasticscm5/theme/avalonia/icons/linunityvcs.ico

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Plastic SCM (or Unity VCS) is a full version control stack used in game development with close integration with Unity engine";
    homepage = "https://www.plasticscm.com";
    downloadPage = "https://www.plasticscm.com/plastic-for-linux";
    changelog = "https://www.plasticscm.com/download/releasenotes";
    license = licenses.unfree;
    maintainers = with maintainers; [silvarc141];
    platforms = ["x86_64-linux"];
    sourceProvenance = with sourceTypes; [binaryNativeCode];
  };
}
