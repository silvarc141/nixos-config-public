{config, lib, ...}:{
  config = lib.mkIf config.programs.thunderbird.enable {
    programs.thunderbird = {
      profiles.${config.home.username} = {
        isDefault = true;
        userChrome = ''
          /* hide tab bar */
          #tabs-toolbar {
            visibility: collapse !important;
          }'';
        # extensions = "";
        settings = {
          # updates
          "app.update.auto" = false;

          # auto enable extensions
          "extensions.autoDisableScopes" = 0;

          # unused features
          "mail.accounthub.enabled" = false;

          # start page
          "mailnews.start_page.enabled" = false;
          "browser.newtabpage.enabled" = false;

          # noise
          "extensions.getAddons.showPane" = false;
          "extensions.htmlaboutaddons.recommendations.enabled" = false;
          "browser.discovery.enabled" = false;
          "browser.startup.homepage_override.mstone" = "ignore";
          "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
          "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
          "app.donation.eoy.version.viewed" = 999;
          "mail.rights.override" = true;
          "mail.shell.checkDefaultClient" = false;

          # telemetry
          "datareporting.policy.dataSubmissionEnabled" = false;
          "datareporting.healthreport.uploadEnabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.server" = "data:,";
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.updatePing.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "toolkit.coverage.opt-out" = true;
          "toolkit.coverage.endpoint.base" = "";
        };
      };
    };
    custom.ephemeral.data.directories = [
      ".thunderbird"
    ];
  };
}
