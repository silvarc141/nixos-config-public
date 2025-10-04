{
  lib,
  fetchgit,
  python3Packages,
  gtk4,
  glib,
  libadwaita,
  lpac,
  meson,
  ninja,
  pkg-config,
  blueprint-compiler,
  desktop-file-utils,
  libxml2,
  wrapGAppsHook4,
}:
python3Packages.buildPythonApplication rec {
  pname = "lpa-gtk";
  version = "0.2";

  src = fetchgit {
    url = "https://codeberg.org/lucaweiss/lpa-gtk.git";
    rev = version;
    hash = "sha256-yzifFQsmeK6w8Cuxa5I1lumSqqGpwWnHVH9C2Jz0MNI=";
  };

  # The definitive fix, provided by the build error itself.
  # This tells the builder to use standard build/install phases (which will use Meson)
  # instead of Python-specific ones, while still providing the crucial Python runtime wrapper.
  format = "other";

  # All the dependencies we correctly discovered together.
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    blueprint-compiler
    desktop-file-utils
    libxml2
    wrapGAppsHook4
  ];

  propagatedBuildInputs = [
    gtk4
    glib
    libadwaita
    lpac
    python3Packages.pygobject3
  ];

  # The 'format = "other"' attribute makes these manual overrides unnecessary and incorrect.
  # dontUseSetuptoolsBuild = true;
  # installPhase = ...;

  meta = with lib; {
    description = "A GTK front-end for lpac";
    homepage = "https://codeberg.org/lucaweiss/lpa-gtk";
    license = licenses.gpl3Only;
    maintainers = with maintainers; []; # Add your handle
    platforms = platforms.linux;
  };
}
