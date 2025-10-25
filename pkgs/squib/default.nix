{
  lib,
  writeShellScriptBin,
  pkg-config,
  ruby,
  rake,
  defaultGemConfig,
  bundlerEnv,
  gobject-introspection,
  gobject-introspection-unwrapped,
  cairo,
  pango,
  gdk-pixbuf,
  librsvg,
  harfbuzz,
  glib,
}: let
  gemConfig =
    defaultGemConfig
    // {
      rsvg2 = attrs: {
        nativeBuildInputs = [pkg-config rake];
        buildInputs = [librsvg];
      };
    };
  gems = bundlerEnv {
    name = "squib";
    inherit ruby;
    inherit gemConfig;
    gemdir = ./.;
  };
  runtimeInputs = [
    gems
    ruby

    gobject-introspection
    gobject-introspection-unwrapped
    cairo
    pango
    gdk-pixbuf
    librsvg
    harfbuzz
    glib
  ];
in
  writeShellScriptBin "squib"
  #sh
  ''
    export PATH="${lib.makeBinPath runtimeInputs}:$PATH"
    export LD_LIBRARY_PATH="${lib.makeLibraryPath runtimeInputs}:$LD_LIBRARY_PATH"
    export GI_TYPELIB_PATH="${lib.makeSearchPathOutput "lib" "lib/girepository-1.0" runtimeInputs}:$GI_TYPELIB_PATH"
    exec squib "$@"
  ''
