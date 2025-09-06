{
  config,
  lib,
  pkgs,
  ...
}: {
  options.custom.email.enable = lib.mkEnableOption "enable email configuration";

  config = let
    maildirPath = ".local/share/maildir";
    gmailAccountNames = builtins.attrNames (lib.filterAttrs (n: v: v.flavor == "gmail.com") config.accounts.email.accounts);
    foreachGmailName = func: (map func gmailAccountNames);
  in
    lib.mkIf (config.custom.email.enable && config.custom.secrets.enable) {
      #     accounts.email = {
      #       maildirBasePath = maildirPath;
      #       accounts = let
      #         mkGmailAccount = name: {
      #           ${name} = {
      #             flavor = "gmail.com";
      #             notmuch.enable = true;
      #             msmtp.enable = true;
      #             astroid.enable = true;
      #             lieer = {
      #               enable = true;
      #               settings = {};
      #               sync.enable = true;
      #             };
      #             thunderbird = {
      #               enable = true;
      #               settings = id: {
      #                 "mail.smtpserver.smtp_${id}.authMethod" = 10;
      #                 "mail.server.server_${id}.authMethod" = 10;
      #               };
      #             };
      #             # himalaya.enable = true;
      #             # passwordCommand = ''cat ${config.sops.secrets."gmail-app-password-${name}".path}'';
      #           };
      #         };
      #       in
      #         lib.mkMerge [
      #           (mkGmailAccount "cspk")
      #           {
      #             cspk = {
      #               primary = true;
      #               address = "cspk00@gmail.com";
      #               realName = "cspk";
      #               signature = {
      #                 text = ''
      #                   --
      #                   cspk
      #                 '';
      #               };
      #             };
      #           }
      #         ];
      #     };
      #
      #     services = {
      #       lieer.enable = true;
      #     };
      #
      #     programs = {
      #       offlineimap = {
      #         enable = true;
      #       };
      #       alot.enable = true;
      #       lieer.enable = true;
      #       notmuch = {
      #         enable = true;
      #         search.excludeTags = [
      #           "trash"
      #           "spam"
      #         ];
      #         # "new" tag is only for processing
      #         new.tags = ["new"];
      #         hooks = let
      #           hook = ''
      #             notmuch tag -new -- tag:new
      #           '';
      #         in {
      #           postInsert = hook;
      #           postNew = hook;
      #         };
      #       };
      #       msmtp.enable = true;
      #       astroid = {
      #         enable = true;
      #         externalEditor = "neovide %1";
      #         # TODO: config saving Drafts and Sent
      #         extraConfig = {
      #           mail = {
      #             user_agent = "";
      #             # close_on_success = true;
      #           };
      #           editor = {
      #             attachment_words = [
      #               "attach"
      #               "załącznik"
      #               "zalącznik"
      #               "załacznik"
      #               "zalacznik"
      #             ];
      #             attachment_directory = "~/unsorted";
      #           };
      #           thread_view = {
      #             default_save_directory = "~/unsorted";
      #             open_html_part_external = true;
      #           };
      #         };
      #       };
      #       thunderbird = {
      #         enable = true;
      #         profiles = {
      #           main.isDefault = true;
      #         };
      #       };
      #       himalaya = {
      #         enable = true;
      #       };
      #     };
      #
      #     sops.secrets = let
      #       mkGmailSecrets = name: {
      #         "gmail-app-password-${name}" = {};
      #         "gmail-oauth-${name}" = {
      #           path = "${maildirPath}/${name}/.credentials.gmailieer.json";
      #         };
      #       };
      #     in
      #       lib.mkMerge (foreachGmailName mkGmailSecrets);
      #
      #     home.activation = let
      #       user = config.home.username;
      #       # lieer's "gmi sync" does not run if cur, new, tmp directories do not exist
      #       setupGmail = name: ''
      #         mkdir -p "/home/${user}/${maildirPath}/${name}/mail/cur"
      #         mkdir -p "/home/${user}/${maildirPath}/${name}/mail/new"
      #         mkdir -p "/home/${user}/${maildirPath}/${name}/mail/tmp"
      #       '';
      #       firstNotmuchNew = ''
      #         if [ ! -d "/home/${user}/${maildirPath}/.notmuch" ]; then
      #           ${pkgs.notmuch}/bin/notmuch new
      #         fi
      #       '';
      #     in {
      #       emailSetup =
      #         lib.hm.dag.entryAfter ["writeBoundary"]
      #         (lib.concatStrings ((foreachGmailName setupGmail) ++ [firstNotmuchNew]));
      #     };
      #
      #     custom.ephemeral = {
      #       local = {
      #         directories = [maildirPath];
      #       };
      #     };
      #
      #     # fix for MSMTP spamming logs in $HOME: https://github.com/nix-community/home-manager/issues/5831
      #     home.sessionVariables = {
      #       MSMTPQ_Q = "${config.xdg.dataHome}/msmtp/queue";
      #       MSMTPQ_LOG = "${config.xdg.dataHome}/msmtp/queue.log";
      #     };
    };
  #
  # # // (mkGmail {
  # #   name = "main";
  # #   extraConfig = {
  # #     accounts.email.accounts = {
  # #       main = {
  # #         primary = true;
  # #         address = "marta.karaniewicz.biedna@gmail.com";
  # #         realName = "Marta Karaniewicz-Biedna";
  # #         signature = {
  # #           text = ''
  # #             --
  # #             Marta Karaniewicz-Biedna
  # #           '';
  # #         };
  # #       };
  # #     };
  # #   };
  # # })
}
