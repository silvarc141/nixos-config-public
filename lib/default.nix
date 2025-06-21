{
  lib,
  pkgs,
  paths,
}: rec {
  writeNuScriptBin = name: text:
    with pkgs;
      writeTextFile {
        inherit name;
        executable = true;
        destination = "/bin/${name}";
        text = ''
          #!${nushell}/bin/nu --stdin
          ${text}
        '';
        meta.mainProgram = name;
      };
  writeNuScriptBinWithLib = name: text:
    writeNuScriptBin name ''
      source ${paths.homeManagerConfig}/minimal/programs/nushell/lib.nu
      ${text}
    '';
  mkNuScriptlet = text:
    lib.getExe (writeNuScriptBin "quick-script" ''
      source ${paths.homeManagerConfig}/minimal/programs/nushell/lib.nu
      ${text}
    '');
  mkTrayService = {
    command,
    description,
    settings ? {},
  }: (lib.recursiveUpdate {
      Unit = {
        Description = description;
        Requires = ["tray.target"];
        After = ["graphical-session.target" "tray.target"];
        PartOf = ["graphical-session.target"];
      };
      Service = {
        ExecStart = command;
        Restart = "on-failure";
      };
      Install.WantedBy = ["graphical-session.target"];
    }
    settings);
  getImportable = pathToDir: map (x: "${pathToDir}/${x}") (builtins.attrNames (readDirImportable pathToDir));
  readDirImportable = pathToDir: let
    forbiddenFileNames = [
      "default.nix"
      "shell.nix"
      "flake.nix"
    ];
    paths = builtins.readDir pathToDir;
    importableDirectories = lib.filterAttrs (n: v: (v == "directory") && builtins.pathExists (pathToDir + "/${n}/default.nix")) paths;
    importableFiles =
      lib.filterAttrs (
        n: v:
          (v == "regular")
          && (builtins.match ".*\\.nix" n) != null
          && (builtins.all (x: n != x) forbiddenFileNames)
      )
      paths;
  in
    importableDirectories // importableFiles;
}
