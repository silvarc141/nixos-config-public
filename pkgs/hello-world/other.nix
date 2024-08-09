{stdenv}:
stdenv.mkDerivation rec {
  name = "hello-world-${version}";
  version = "1.0";
  src = ./.;
  buildPhase = "echo echo HelloWorld > hello-world";
  installPhase = "install -Dm755 hello-world $out";
}
