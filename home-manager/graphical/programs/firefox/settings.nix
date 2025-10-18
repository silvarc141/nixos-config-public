{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.programs.firefox.enable {
    programs.firefox = {
      modal = {
        enable = true;
      };
      languagePacks = ["en-US"];
      policies = {
        # Lock to this config only
        AppAutoUpdate = false;
        BackgroundAppUpdate = false;
        DisableProfileImport = true;

        # Autofill
        PasswordManagerEnabled = false;
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        DisableFormHistory = true;
        DisablePasswordReveal = true;
        OfferToSaveLogins = false;

        # Security
        DisableBuiltinPDFViewer = true;
        PDFjs.Enabled = false;

        # Hardware
        HardwareAcceleration = true;

        # Privacy
        DisableFirefoxStudies = true;
        DisableFirefoxAccounts = true;
        DisableFirefoxScreenshots = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DisableMasterPasswordCreation = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
          EmailTracking = true;
        };
        EncryptedMediaExtensions = {
          Enabled = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
          EmailTracking = true;
        };

        # Data
        SanitizeOnShutdown = {
          Locked = true;
          Cache = true;
          SiteSettings = false;
          OfflineApps = false;
          Cookies = false;
          Sessions = false;
          History = false;
        };

        # UI
        ShowHomeButton = false;
        DisableForgetButton = true;
        DisplayMenuBar = "default-off";
        DisplayBookmarksToolbar = "never";
        DisableProfileRefresh = true;
        DisableSetDesktopBackground = true;

        # Noise
        DontCheckDefaultBrowser = true;
        FirefoxHome = {
          Locked = true;
          Search = false;
          TopSites = false;
          SponsoredTopSites = false;
          Highlights = false;
          Pocket = false;
          SponsoredPocket = false;
          Snippets = false;
        };
        FirefoxSuggest = {
          Locked = true;
          WebSuggestions = false;
          SponsoredSuggestions = false;
          ImproveSuggest = false;
        };
        UserMessaging = {
          Locked = true;
          WhatsNew = false;
          ExtensionRecommendations = false;
          FeatureRecommendations = false;
          MoreFromMozilla = false;
          SkipOnboarding = true;
          UrlbarInterventions = false;
          FirefoxLabs = false;
        };
        NoDefaultBookmarks = true;

        # File handling
        DefaultDownloadDirectory = "\${home}/${config.custom.home.unsorted}";
        DownloadDirectory = "\${home}/${config.custom.home.unsorted}";
        Handlers = {
          schemes = {
            mailto = {
              action = "useHelperApp";
              ask = false;
              handlers = [null];
            };
            magnet = {
              action = "useHelperApp";
              ask = false;
              handlers = [
                {
                  name = "qBittorrent";
                  path = "${pkgs.qbittorrent}/bin/qbittorrent";
                }
              ];
            };
          };
          extensions = {
            pdf = {
              action = "useHelperApp";
              ask = false;
              handlers = [
                {
                  name = "zathura";
                  path = "${pkgs.zathura}/bin/zathura";
                }
              ];
            };
            webp = {
              action = "useHelperApp";
              ask = false;
              handlers = [
                {
                  name = "feh";
                  path = "${pkgs.feh}/bin/feh";
                }
              ];
            };
            avif = {
              action = "useHelperApp";
              ask = false;
              handlers = [
                {
                  name = "feh";
                  path = "${pkgs.feh}/bin/feh";
                }
              ];
            };
          };
        };

        # Extensions
        ExtensionUpdate = true;
        ExtensionSettings = let
          # key: search in extension store page source for -> "guid": <- and use the id
          # value: last part of extension store page url
          sources = {
            "uBlock0@raymondhill.net" = "ublock-origin";
            "addon@darkreader.org" = "darkreader";
            # breaks too much by default, reenable if more patient
            # "skipredirect@sblask" = "skip-redirect";
          };
        in
          (lib.mapAttrs (name: value: {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/${value}/latest.xpi";
              installation_mode = "force_installed";
            })
            sources)
          // {"*".installation_mode = "blocked";};

        # some cool extensions to consider:
        # buster-captcha-solver
        # aw-watcher-web
        # keepassxc-browser
        # firenvim
        #
        # obsolete:
        # istilldontcareaboutcookies - enabling cookie notices filter in ublock origin should be enough
      };
      profiles."${config.home.username}" = {
        id = 0;
        isDefault = true;
        search = {
          default = "ddg";
          force = true;
          engines = {
            "Noogle" = {
              urls = [
                {
                  template = "https://noogle.dev/q";
                  params = [
                    {
                      name = "term";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@ng"];
            };
            "nixpkgs-stable" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "channel";
                      value = "25.05";
                    }
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
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@np"];
            };
            "nixpkgs-unstable" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "channel";
                      value = "unstable";
                    }
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
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@npu"];
            };
            "Nixvim" = {
              urls = [
                {
                  template = "https://nix-community.github.io/nixvim";
                  params = [
                    {
                      name = "search";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.moka-icon-theme}/share/icons/Moka/32x32/apps/vim.png";
              definedAliases = ["@nv"];
            };
            "youtube" = {
              urls = [
                {
                  template = "https://www.youtube.com/results";
                  params = [
                    {
                      name = "search_query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.moka-icon-theme}/share/icons/Moka/32x32/web/YouTube-youtube.com.png";
              definedAliases = ["@yt"];
            };
            "OpenStreetMap" = {
              urls = [
                {
                  template = "https://www.openstreetmap.org/search";
                  params = [
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.moka-icon-theme}/share/icons/Moka/32x32/web/maps.png";
              definedAliases = ["@osm"];
            };
            "Searchfox" = {
              urls = [
                {
                  template = "https://searchfox.org/mozilla-central/search";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                    {
                      name = "path";
                      value = "";
                    }
                    {
                      name = "case";
                      value = "false";
                    }
                    {
                      name = "regexp";
                      value = "false";
                    }
                  ];
                }
              ];
              icon = "${pkgs.moka-icon-theme}/share/icons/Moka/32x32/apps/firefox-developer.png";
              definedAliases = ["@sf"];
            };
            "protondb" = {
              urls = [
                {
                  template = "https://www.protondb.com/search";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.moka-icon-theme}/share/icons/Moka/32x32/apps/wine.png";
              definedAliases = ["@pdb"];
            };
            "ebay".metaData.hidden = true;
            "bing".metaData.hidden = true;
            "google".metaData.hidden = true;
          };
        };
        settings = {
          # devtools
          "devtools.chrome.enabled" = true;
          "devtools.debugger.remote-enabled" = true;

          # permissions
          "permissions.default.shortcuts" = 2; # block site shortcuts
          "permissions.default.geo" = 2;
          "permissions.default.desktop-notification" = 2;

          # performance
          "gfx.webrender.all" = true; # force enable gpu acceleration
          "media.ffmpeg.vaapi.enabled" = true;

          # updates
          "app.update.auto" = false; # updates managed by nix

          # extensions
          "extensions.autoDisableScopes" = 0; # don't disable extensions by default

          # unused features
          "extension.pocket.enabled" = false;
          "identity.fxaccounts.enabled" = false;
          "browser.ctrlTab.recentlyUsedOrder" = false;
          "browser.discovery.enabled" = false;
          "browser.laterrun.enabled" = false;

          "browser.contentblocking.category" = "strict"; # ?

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
          "browser.startup.couldRestoreSession.count" = 2;

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
          "browser.translations.neverTranslateLanguages" = "en-US,pl";

          # startup page
          "browser.startup.page" = 1; # set to home page

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

          # address bar
          "browser.urlbar.suggest.openpage" = false;
          "browser.urlbar.suggest.engines" = false;
          "browser.urlbar.suggest.searches" = false;
          "browser.urlbar.suggest.topsites" = false;
          "browser.urlbar.placeholderName" = "...";

          # while this is on, there is a bug with firefox-modal - selecting an option from firefox suggest searches for current text instead
          "browser.urlbar.autoFill" = false;

          # ui
          "browser.compactmode.show" = true;
          "browser.fullscreen.autohide" = false;
          "browser.uiCustomization.state" = builtins.toJSON {
            placements = {
              widget-overflow-fixed-list = [];
              unified-extensions-area = [
                "skipredirect_sblask-browser-action"
                "addon_darkreader_org-browser-action"
                "ublock0_raymondhill_net-browser-action"
              ];
              nav-bar = [
                "back-button"
                "forward-button"
                "stop-reload-button"
                "urlbar-container"
                "downloads-button"
                "fxa-toolbar-menu-button"
                "unified-extensions-button"
              ];
              toolbar-menubar = [
                "menubar-items"
              ];
              TabsToolbar = [
                "tabbrowser-tabs"
                "new-tab-button"
              ];
              vertical-tabs = [];
              PersonalToolbar = [
                "personal-bookmarks"
              ];
            };
            seen = [
              "developer-button"
              "skipredirect_sblask-browser-action"
              "addon_darkreader_org-browser-action"
              "ublock0_raymondhill_net-browser-action"
            ];
            dirtyAreaCache = [
              "nav-bar"
              "vertical-tabs"
              "unified-extensions-area"
              "toolbar-menubar"
              "TabsToolbar"
              "PersonalToolbar"
              "widget-overflow-fixed-list"
            ];
            currentVersion = 20;
            newElementCount = 2;
          };

          "accessibility.tabfocus" = 1;
        };
      };
    };
    # this refreshes only after wipe, a kind of initial config
    home.file.".mozilla/managed-storage/uBlock0@raymondhill.net.json".text = builtins.toJSON {
      name = "uBlock0@raymondhill.net";
      description = "Declarative configuration for uBlock Origin";
      type = "storage";
      data = {
        userSettings = [
          ["advancedUserEnabled" "true"]
          ["dynamicFilteringEnabled" "true"]
        ];
        toOverwrite.filterLists = [
          "user-filters"
          "ublock-filters"
          "ublock-badware"
          "ublock-privacy"
          "ublock-abuse"
          "ublock-unbreak"
          "ublock-quick-fixes"
          "easylist"
          "easyprivacy"
          "urlhaus-1"
          "plowe-0"

          "adguard-cookies"
          "ublock-cookies-adguard"

          "adguard-social"
          "fanboy-thirdparty_social"
          "adguard-popup-overlays"
          "adguard-mobile-app-banners"
          "adguard-other-annoyances"
          "adguard-widgets"
          "easylist-annoyances"
          "easylist-chat"
          "easylist-newsletters"
          "easylist-notifications"
          "ublock-annoyances"

          "POL-0"
          "POL-2"
        ];
        toAdd.trustedSiteDirectives = [
          "mbank.pl"
        ];
      };
    };
  };
}
