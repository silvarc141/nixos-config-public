{pkgs}: rec {
  getImportable = pathToDir: map (x: "${pathToDir}/${x}") (builtins.attrNames (readDirImportable pathToDir));
  readDirImportable = pathToDir: let
    forbiddenFileNames = [
      "default.nix"
      "shell.nix"
      "flake.nix"
    ];
    paths = builtins.readDir pathToDir;
    importableDirectories = pkgs.lib.filterAttrs (n: v: (v == "directory") && builtins.pathExists (pathToDir + "/${n}/default.nix")) paths;
    importableFiles =
      pkgs.lib.filterAttrs (
        n: v:
          (v == "regular")
          && (builtins.match ".*\\.nix" n) != null
          && (builtins.all (x: n != x) forbiddenFileNames)
      )
      paths;
  in
    importableDirectories // importableFiles;
  writeNuScriptBin = name: text:
    pkgs.writeTextFile {
      inherit name;
      executable = true;
      destination = "/bin/${name}";
      text = ''
        #!${pkgs.nushell}/bin/nu --stdin
        ${text}
      '';
      meta.mainProgram = name;
    };
  mkTrayService = {
    command,
    description,
    settings ? {},
  }: (pkgs.lib.recursiveUpdate {
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
}
