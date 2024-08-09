{
  pkgs,
  inputs,
  nixosConfig,
  ...
}: let cfg = nixosConfig.capabilities; in {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox.override {
      nativeMessagingHosts = [
        pkgs.tridactyl-native
      ];
    };
    policies = {
      AppAutoUpdate = false; # Disable automatic application update
      BackgroundAppUpdate = false; # Disable automatic application update in the background, when the application is not running.
      DisableBuiltinPDFViewer = true; # Considered a security liability
      DisableFirefoxStudies = true;
      DisableFirefoxAccounts = true; # Disable Firefox Sync
      DisableFirefoxScreenshots = true; # No screenshots
      DisableForgetButton = true;
      DisableMasterPasswordCreation = true;
      DisableProfileImport = true; # Purity enforcement: Only allow nixdefined profiles
      DisableProfileRefresh = true; # Disable the Refresh Firefox button on about:support and support.mozilla.org
      DisableSetDesktopBackground = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DisableFormHistory = true;
      DisablePasswordReveal = true;
      DisplayMenuBar = "default-off";
      DisplayBookmarksToolbar = "never";
      DontCheckDefaultBrowser = true;
      OfferToSaveLogins = false;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
        EmailTracking = true;
        # Exceptions = ["https://example.com"]
      };
      EncryptedMediaExtensions = {
        Enabled = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
        EmailTracking = true;
        # Exceptions = ["https://example.com"]
      };
      ExtensionUpdate = false;
      Handlers = {
        schemes.mailto.handlers = [null];
      };
      FirefoxHome = {
        Search = false;
        TopSites = false;
        SponsoredTopSites = false;
        Highlights = false;
        Pocket = false;
        SponsoredPocket = false;
        Snippets = false;
        Locked = true;
      };
      FirefoxSuggest = {
        WebSuggestions = false;
        SponsoredSuggestions = false;
        ImproveSuggest = false;
        Locked = true;
      };
      SearchEngines = {
        PreventInstalls = true;
        Remove = [
          "Amazon.com"
          "Bing"
          "Google"
          "Wikipedia (en)"
        ];
      };
      UserMessaging = {
        Locked = true;
        ExtensionRecommendations = false; # Don’t recommend extensions while the user is visiting web pages
        FeatureRecommendations = false; # Don’t recommend browser features
        MoreFromMozilla = false; # Don’t show the “More from Mozilla” section in Preferences
        SkipOnboarding = true; # Don’t show onboarding messages on the new tab page
        UrlbarInterventions = false; # Don’t offer suggestions in the URL bar
        WhatsNew = false; # Remove the “What’s New” icon and menuitem
      };
      NoDefaultBookmarks = true;
      DownloadDirectory = "$HOME/downloads";
      ShowHomeButton = false;
      /*
        ExtensionSettings = {
        "*" = {
          installation_mode = "blocked";
          blocked_install_message = "Extension installation disabled. Add extensions through nix configuration";
        };
        #"7esoorv3@alefvanoon.anonaddy.me" = {
        #  # LibRedirect
        #  install_url = "file:///${inputs.firefoxaddons.packages.x86_64linux.libredirect}/share/mozilla/extensions/{ec8030f7c20a464f9b0e13a3a9e97384}/7esoorv3@alefvanoon.anonaddy.me.xpi";
        #  installation_mode = "force_installed";
        #};
      };
      */
    };
    profiles."${cfg.singleUser.name}" = {
      id = 0;
      isDefault = true;
      search = {
        default = "DuckDuckGo";
        force = true;
        engines = {
          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            "Bing".metaData.hidden = true;
            "Google".metaData.hidden = true;
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@np"];
          };
        };
      };
      settings = {
        # performance
        "gfx.webrender.all" = true; # force enable gpu acceleration
        "media.ffmpeg.vaapi.enabled" = true;

        # updates
        "app.update.auto" = false; # updates managed by nix

        # download
        "browser.download.useDownloadDir" = false;
        #"browser.download.dir" = "$HOME/downloads";

        # extensions
        "extensions.autoDisableScopes" = 0; # don't disable extensions by default

        # unused features
        "extension.pocket.enabled" = false;
        "identity.fxaccounts.enabled" = false;
        "browser.contentblocking.category" = "strict";
        "browser.ctrlTab.recentlyUsedOrder" = false;
        "browser.discovery.enabled" = false;
        "browser.laterrun.enabled" = false;

        # security
        "dom.security.https_only_mode" = true;
        "signon.autofillForms" = false;
        "signon.firefoxRelay.feature" = "disabled";
        "signon.generation.enabled" = "false";
        "signon.management.page.breach-alerts.enabled" = "false";
        "signon.rememberSignons" = false;

        # privacy
        "app.shield.optoutstudies.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "datareporting.policy.dataSubmissionPolicyAcceptedVersion" = "2";
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;

        # first run
        "app.normandy.first_run" = false;
        "toolkit.telemetry.reportingpolicy.firstRun" = false;
        "browser.download.panel.shown" = true;
        "browser.translations.panelShown" = true;
        "browser.aboutConfig.showWarning" = false;

        # first run welcome
        "trailhead.firstrun.didSeeAboutWelcome" = true;
        "browser.aboutwelcome.enabled" = false;

        # first run bookmarks
        "browser.bookmarks.restore_default_bookmarks" = false;
        "browser.bookmarks.addedImportButton" = false;

        # cookie notices
        "cookiebanners.service.mode" = 2;
        "cookiebanners.service.mode.privateBrowsing" = 2;

        # localization
        "general.useragent.locale" = "en-US";
        "browser.translations.neverTranslateLanguages" = "en, en-US, pl";

        # startup page
        "browser.startup.page" = 1; # set to home page

        # home page
        #"browser.startup.homepage" = "moz-extension://9b5145a6-344f-4a4d-a35c-969c3fe97ee2/pages/blank.html"; # set to vimium's "pages/blank" - check if this id is unique to vimium

        # new tab page
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
        "browser.newtabpage.activity-stream.feeds.snippets" = false;
        "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.havePinned" = "";
        "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.searchEngines" = "";
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.pinned" = [];

        # urlbar
        "browser.urlbar.placeholderName" = "...";
        "browser.urlbar.suggest.openpage" = false;

        # ui
        "browser.compactmode.show" = true;
        "browser.uiCustomization.state" = ''
          {
            "placements":{
              "widget-overflow-fixed-list":[],
              "unified-extensions-area":[],
              "nav-bar":[
                "back-button",
                "forward-button",
                "stop-reload-button",
                "urlbar-container",
                "downloads-button",
                "fxa-toolbar-menu-button",
                "unified-extensions-button"
              ],
              "toolbar-menubar":[ "menubar-items" ],
              "TabsToolbar":[
                "tabbrowser-tabs",
                "new-tab-button",
                "alltabs-button"
              ],
              "PersonalToolbar":[ "personal-bookmarks" ]
            },
            "seen":[
              "save-to-pocket-button",
              "developer-button"
            ],
            "dirtyAreaCache":[
              "nav-bar",
              "toolbar-menubar",
              "TabsToolbar",
              "PersonalToolbar"
            ],
            "currentVersion":20,
            "newElementCount":2
          }'';
      };
      extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
        ublock-origin
        darkreader
        tridactyl
        #vimium
        privacy-badger
        istilldontcareaboutcookies
        buster-captcha-solver
        #onepassword-password-manager
        #libredirect
      ];
    };
  };
}
