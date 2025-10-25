{
  stdenv,
  lib,
  rustPlatform,
  pkg-config,
  fetchFromGitHub,
  alsa-lib,
}:
rustPlatform.buildRustPackage rec {
  pname = "nu_plugin_audio_hook";
  cargoHash = "sha256-Q/j6ySibYN5VKrxHU4/mp+m1cheXP3dC0HcomY9gH3E=";
  version = "9a7d7d23d0aeffa11a154887541dcde17344d763";

  src = fetchFromGitHub {
    owner = "FMotalleb";
    repo = pname;
    rev = version;
    hash = "sha256-Fw/cH2GgmWaNGkZ67nDwr2u4ujFOjQV5T6AbdY0oIyc=";
  };

  cargoBuildFlags = ["--features=all-decoders"];

  nativeBuildInputs = [pkg-config] ++ lib.optionals stdenv.cc.isClang [rustPlatform.bindgenHook];
  buildInputs = [alsa-lib.dev];

  LD_LIBRARY_PATH = lib.makeLibraryPath buildInputs;

  meta = with lib; {
    description = "Audio plugin for Nushell";
    mainProgram = "nu_plugin_audio_hook";
    platforms = with platforms; all;
  };
}
