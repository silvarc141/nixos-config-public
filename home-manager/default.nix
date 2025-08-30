{
  paths,
  homeType ? "minimal",
  ...
}: {
  imports = [
    ./modules
    ./minimal
    ./graphical
    (import "${paths.homeManagerConfig}/homes/${homeType}.nix")
  ];
}
