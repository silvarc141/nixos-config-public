{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.programs.vesktop.enable {
    programs.vesktop = {
      settings = {
        discordBranch = "stable";
        arRPC = false;
        disableMinSize = true;
        audio.granularSelect = false;
        minimizeToTray = false;
        tray = false;
      };
      vencord = {
        useSystem = false;
        settings = {
          autoUpdate = true;
          autoUpdateNotification = true;
          useQuickCss = true;
          themeLinks = ["https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css"];
          enabledThemes = [];
          enableReactDevtools = false;
          frameless = false;
          transparent = false;
          winCtrlQ = false;
          disableMinSize = false;
          winNativeTitleBar = false;
          notifications = {
            timeout = 5000;
            position = "top-right";
            useNative = "never";
            logLimit = 50;
          };
          plugins = {
            ChatInputButtonAPI.enabled = true;
            CommandsAPI.enabled = true;
            MemberListDecoratorsAPI.enabled = true;
            MessageAccessoriesAPI.enabled = true;
            MessageDecorationsAPI.enabled = true;
            MessageEventsAPI.enabled = true;
            MessageUpdaterAPI.enabled = true;
            MessagePopoverAPI.enabled = false;
            ServerListAPI.enabled = false;
            UserSettingsAPI.enabled = true;

            AlwaysAnimate.enabled = true;
            # AlwaysExpandRoles.enabled = true;
            AlwaysTrust = {
              enabled = true;
              domain = true;
              file = true;
            };
            AnonymiseFileNames.enabled = false;
            AppleMusicRichPresence.enabled = false;
            "WebRichPresence (arRPC)".enabled = false;
            BANger.enabled = false;
            BetterGifAltText.enabled = false;
            BetterGifPicker.enabled = false;
            BetterNotesBox = {
              enabled = false;
              hide = false;
              noSpellCheck = false;
            };
            BetterRoleContext.enabled = false;
            BetterRoleDot = {
              enabled = true;
              bothStyles = false;
              copyRoleColorInProfilePopout = false;
            };
            BetterSessions = {
              enabled = false;
              backgroundCheck = false;
              checkInterval = 20;
            };
            BetterSettings = {
              enabled = false;
              disableFade = true;
              organizeMenu = true;
              eagerLoad = true;
            };
            BetterUploadButton.enabled = true;
            BiggerStreamPreview.enabled = true;
            BlurNSFW = {
              enabled = true;
              blurAmount = 10;
            };
            CallTimer = {
              enabled = true;
              format = "stopwatch";
            };
            ClearURLs.enabled = false;
            ClientTheme.enabled = false;
            ColorSighted.enabled = false;
            ConsoleJanitor.enabled = false;
            ConsoleShortcuts.enabled = true;
            CopyEmojiMarkdown.enabled = false;
            CopyFileContents.enabled = false;
            CopyUserURLs.enabled = false;
            CrashHandler.enabled = true;
            CtrlEnterSend = {
              enabled = false;
              submitRule = "ctrl+enter";
              sendMessageInTheMiddleOfACodeBlock = true;
            };
            CustomRPC.enabled = false;
            CustomIdle = {
              enabled = false;
              idleTimeout = 0;
            };
            Dearrow = {
              enabled = true;
              hideButton = false;
              replaceElements = 0;
              dearrowByDefault = true;
            };
            Decor.enabled = false;
            DisableCallIdle.enabled = true;
            DontRoundMyTimestamps.enabled = false;
            EmoteCloner.enabled = false;
            Experiments = {
              enabled = false;
              toolbarDevMenu = false;
            };
            F8Break.enabled = false;
            FakeNitro.enabled = false;
            FakeProfileThemes.enabled = false;
            FavoriteEmojiFirst.enabled = false;
            FavoriteGifSearch.enabled = false;
            FixCodeblockGap.enabled = false;
            FixSpotifyEmbeds.enabled = false;
            FixYoutubeEmbeds.enabled = true;
            ForceOwnerCrown.enabled = true;
            FriendInvites.enabled = true;
            FriendsSince.enabled = false;
            FullSearchContext.enabled = true;
            GameActivityToggle.enabled = false;
            GifPaste.enabled = false;
            GreetStickerPicker.enabled = false;
            HideAttachments.enabled = false;
            iLoveSpam.enabled = false;
            IgnoreActivities = {
              enabled = false;
              listMode = 0;
              idsList = "";
              ignorePlaying = false;
              ignoreStreaming = false;
              ignoreListening = false;
              ignoreWatching = false;
              ignoreCompeting = false;
            };
            ImageLink.enabled = false;
            ImageZoom = {
              enabled = true;
              saveZoomValues = true;
              invertScroll = true;
              nearestNeighbour = false;
              square = false;
              zoom = 3;
              size = 500;
              zoomSpeed = 0.5;
            };
            ImplicitRelationships.enabled = false;
            InvisibleChat.enabled = false;
            KeepCurrentChannel.enabled = false;
            LastFMRichPresence.enabled = false;
            LoadingQuotes.enabled = false;
            MemberCount.enabled = false;
            MentionAvatars.enabled = false;
            MessageClickActions.enabled = false;
            MessageLatency.enabled = false;
            MessageLinkEmbeds.enabled = false;
            MessageLogger = {
              enabled = true;
              deleteStyle = "text";
              logDeletes = true;
              collapseDeleted = true;
              logEdits = true;
              inlineEdits = false;
              ignoreBots = true;
              ignoreSelf = false;
              ignoreUsers = "";
              ignoreChannels = "";
              ignoreGuilds = "";
            };
            MessageTags.enabled = false;
            MoreCommands.enabled = false;
            MoreKaomoji.enabled = false;
            MoreUserTags.enabled = false;
            Moyai.enabled = false;
            MutualGroupDMs.enabled = false;
            NewGuildSettings = {
              enabled = true;
              guild = true;
              messages = 3;
              everyone = true;
              role = true;
              highlights = true;
              events = true;
              showAllChannels = true;
            };
            NoBlockedMessages.enabled = false;
            NoDefaultHangStatus.enabled = false;
            NoDevtoolsWarning.enabled = false;
            NoF1.enabled = true;
            NoMaskedUrlPaste.enabled = false;
            NoMosaic.enabled = false;
            NoOnboardingDelay.enabled = false;
            NoPendingCount.enabled = false;
            NoProfileThemes.enabled = false;
            NoReplyMention = {
              enabled = true;
              userList = "1234567890123445;1234567890123445";
              shouldPingListed = true;
              inverseShiftReply = true;
            };
            NoScreensharePreview.enabled = true;
            NoServerEmojis.enabled = false;
            NoTypingAnimation.enabled = false;
            NoUnblockToJump.enabled = false;
            NormalizeMessageLinks.enabled = false;
            NotificationVolume.enabled = false;
            NSFWGateBypass.enabled = false;
            OnePingPerDM = {
              enabled = false;
              channelToAffect = "both_dms";
              allowMentions = false;
              allowEveryone = false;
            };
            oneko.enabled = false;
            OpenInApp = {
              enabled = false;
              spotify = true;
              steam = true;
              epic = true;
              tidal = true;
              itunes = true;
            };
            OverrideForumDefaults.enabled = false;
            PartyMode.enabled = false;
            PauseInvitesForever.enabled = false;
            PermissionFreeWill = {
              enabled = false;
              lockout = true;
              onboarding = true;
            };
            PermissionsViewer.enabled = false;
            petpet.enabled = true;
            PictureInPicture.enabled = true;
            PinDMs.enabled = false;
            PlainFolderIcon.enabled = true;
            PlatformIndicators = {
              enabled = true;
              list = true;
              badges = true;
              messages = false;
              colorMobileIndicator = true;
            };
            PreviewMessage.enabled = true;
            PronounDB.enabled = false;
            QuickMention.enabled = false;
            QuickReply.enabled = false;
            ReactErrorDecoder.enabled = false;
            ReadAllNotificationsButton.enabled = false;
            RelationshipNotifier.enabled = {
              enabled = true;
              notices = true;
              offlineRemovals = true;
              friends = true;
              friendRequestCancels = true;
              servers = true;
              groups = true;
            };
            ReplaceGoogleSearch = {
              enabled = true;
              customEngineName = "Websearch";
              customEngineURL = "https://duckduckgo.com/?q=";
            };
            ReplyTimestamp.enabled = false;
            RevealAllSpoilers.enabled = false;
            ReverseImageSearch.enabled = true;
            ReviewDB = {
              enabled = false;
              notifyReviews = true;
              showWarning = true;
              hideTimestamps = false;
              hideBlockedUsers = true;
            };
            RoleColorEverywhere.enabled = false;
            SearchReply.enabled = false;
            SecretRingToneEnabler.enabled = false;
            Summaries = {
              enabled = true;
              summaryExpiryThresholdDays = 3;
            };
            SendTimestamps.enabled = false;
            ServerInfo.enabled = false;
            ServerListIndicators.enabled = false;
            ShikiCodeblocks.enabled = false;
            ShowAllMessageButtons.enabled = false;
            ShowConnections.enabled = false;
            ShowHiddenChannels.enabled = false;
            ShowHiddenThings = {
              enabled = false;
              showTimeouts = true;
              showInvitesPaused = true;
              showModView = true;
              disableDiscoveryFilters = true;
              disableDisallowedDiscoveryFilters = true;
            };
            ShowMeYourName = {
              enabled = true;
              mode = "user-nick";
              displayNames = false;
              inReplies = true;
            };
            ShowTimeoutDuration.enabled = false;
            SilentMessageToggle.enabled = false;
            SilentTyping = {
              enabled = true;
              showIcon = false;
              contextMenu = true;
              isEnabled = true;
            };
            SortFriendRequests = {
              enabled = true;
              showDates = true;
            };
            SpotifyControls.enabled = false;
            SpotifyCrack.enabled = false;
            SpotifyShareCommands.enabled = false;
            StartupTimings.enabled = true;
            StickerPaste.enabled = false;
            StreamerModeOnStream.enabled = false;
            SuperReactionTweaks = {
              enabled = false;
              superReactByDefault = true;
              unlimitedSuperReactionPlaying = false;
              superReactionPlayingLimit = 20;
            };
            TextReplace.enabled = false;
            ThemeAttributes.enabled = false;
            TimeBarAllActivities.enabled = false;
            Translate = {
              enabled = true;
              showChatBarButton = true;
              service = "google";
              autoTranslate = false;
              showAutoTranslateTooltip = true;
            };
            TypingIndicator = {
              enabled = true;
              includeCurrentChannel = true;
              includeMutedChannels = false;
              includeBlockedUsers = false;
              indicatorMode = 3;
            };
            TypingTweaks = {
              enabled = true;
              showAvatars = true;
              showRoleColors = true;
              alternativeFormatting = true;
            };
            Unindent.enabled = true;
            UnlockedAvatarZoom = {
              enabled = true;
              zoomMultiplier = 4;
            };
            UnsuppressEmbeds.enabled = false;
            UserVoiceShow = {
              enabled = true;
              showInUserProfileModal = true;
              showInMemberList = true;
              showInMessages = true;
            };
            USRBG = {
              enabled = false;
              nitroFirst = true;
              voiceBackground = true;
            };
            ValidReply.enabled = false;
            ValidUser.enabled = false;
            VoiceChatDoubleClick.enabled = false;
            VcNarrator.enabled = false;
            VencordToolbox.enabled = false;
            ViewIcons.enabled = false;
            ViewRaw.enabled = false;
            VoiceDownload.enabled = false;
            VoiceMessages.enabled = false;
            VolumeBooster = {
              enabled = true;
              multiplier = 3;
            };
            WebKeybinds.enabled = true;
            WebScreenShareFixes.enabled = true;
            WhoReacted.enabled = true;
            XSOverlay.enabled = false;
            YoutubeAdblock.enabled = true;
            BadgeAPI.enabled = true;
            NoTrack = {
              enabled = true;
              disableAnalytics = true;
            };
            WebContextMenus = {
              enabled = true;
              addBack = true;
            };
            Settings = {
              enabled = true;
              settingsLocation = "aboveNitro";
            };
            SupportHelper.enabled = true;
          };
        };
      };
    };
    custom.ephemeral = {
      data = {
        directories = [
          ".config/vesktop/sessionData"
          # temporarily persist vencord settings until they are configured properly
          ".config/vesktop/settings"
        ];
      };
      local = {
        directories = [
          ".config/vesktop/Crashpad"
        ];
        files = [
          ".config/vesktop/state.json"
        ];
      };
      cache.directories = [
        ".pki/nssdb" # chromium's Network Security Services location
      ];
    };
    wayland.windowManager.hyprland = lib.mkIf config.wayland.windowManager.hyprland.enable {
      settings = {
        windowrulev2 = [
          "tile, initialClass:^(vesktop)$"
          "workspace 8 silent, initialClass:^(vesktop)$"
        ];
      };
    };
  };
}
