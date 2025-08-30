{
  lib,
  stdenv,
  runCommand,
  megacmd,
}: let
  fetchFromMega = {
    url,
    hash,
  }:
    runCommand (lib.strings.sanitizeDerivationName url) {
      inherit url;
      outputHash = hash;
      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
      preferLocalBuild = true;
      allowSubstitutes = false;
      nativeBuildInputs = [megacmd];
    } ''
      export HOME=$TMPDIR
      mega-cmd-server &
      SERVER_PID=$!
      sleep 2
      mega-exec get "$url" $out
      kill $SERVER_PID
    '';
in
  stdenv.mkDerivation {
    pname = "ssf2";
    version = "1.3.1.2 beta";
    src = fetchFromMega {
      url = "https://mega.nz/file/03oBzQAQ#OUAjbGQ1sqm7nDk5tEOHiIqbIteqJjCiHtXhWcVs66o";
      hash = "sha256-n1+5BLyVMH49zAm6hrtbojr80tJWytXluiRwV4ip27Y=";
    };
    unpackCmd = "mkdir -p data; tar -xf $src -C data";
    installPhase = ''
      runHook preInstall

      # setup flash player trusted folder
      SETTINGS_DIR=$out/home/.macromedia/Flash_Player/#Security/FlashPlayerTrust
      mkdir -p $SETTINGS_DIR
      echo $(readlink -f ./data) >> $SETTINGS_DIR/SSF2.cfg

      mv SSF2 data/ $out
      mkdir -p $out/bin

      cat > "$out/bin/ssf2" <<EOF
        #!/bin/env bash
        export HOME="$out/home"
        "$out/data/fp64" "$out/data/run"
      EOF

      chmod +x "$out/bin/ssf2"

      runHook postInstall
    '';
  }
