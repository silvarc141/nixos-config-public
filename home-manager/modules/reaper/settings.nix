{
  config,
  lib,
  pkgs,
  customUtils,
  ...
}: let
  inherit (lib) mkIf mkOption types literalExpression getExe;
  cfg = config.programs.reaper;
  format = pkgs.formats.ini {};
  staticSettingsFile = format.generate "reapack-declarative-settings.ini" cfg.settings;
  targetFile = "${config.xdg.configHome}/REAPER/reaper.ini";

  impureIniMergerScript = customUtils.writeNuScriptBinWithPlugins {
    name = "merge-reapack-ini";
    plugins = [pkgs.nushellPlugins.formats];
    text =
      #nu
      ''
        def "to ini" [] {
          let input = $in
          ($in | columns) | each {
            let section_name = $in
            let section_header = $'[($section_name)]'
            let section_data = ($input | get $section_name)
            let section_key_values = $section_data | each { items {|key, value| $'($key)=($value)' } }
            let section_full = ([$section_header] ++ $section_key_values) | str join "\n" | str trim
            $section_full
          } | str join "\n\n"
        }

        let static_path = '${staticSettingsFile}'
        let target_path = '${targetFile}'

        let target_dir = ($target_path | path dirname)
        mkdir $target_dir

        let impure_data = (try { open $target_path } catch { {} })
        let static_data = (open $static_path)
        print $static_data

        let merged_data = ($impure_data | merge $static_data)

        $merged_data | to ini | save --force $target_path
      '';
  };
in {
  options.programs.reaper = {
    settings = mkOption {
      type = types.attrsOf (types.attrsOf types.str);
      default = {};
      description = "Declarative REAPER settings written to reaper.ini. Merges with existing reaper.ini, overriding imperative configuration where needed.";
      example = literalExpression ''
        {
          reaper = {
            altpeaks = "5";
            altpeakspath = "/home/silvarc/.local/share/reaper/peaks/";
            autosavedir = "/home/silvarc/.local/share/reaper/backup-auto/";
            autosavedir_unsaved = "/home/silvarc/.local/share/reaper/backup-unsaved/";
          };
        }
      '';
    };
  };

  config = mkIf cfg.enable {
    home.activation.reapackConfig = lib.hm.dag.entryAfter ["writeBoundary"] (getExe impureIniMergerScript);
  };
}
