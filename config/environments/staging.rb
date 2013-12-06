SnaptivistWeb::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  # Add the config.action_mailer.default_url_options
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }

  ###########################################################################################################
  # Application logging
  #

  # Log detail
  config.log_level = :debug
  
   ###########################################################################################################
  # User notifications
  #
  require 'user_notification.rb'
  require 'elastic_email_email_user_notifier.rb'
  router = UserNotification::UserNotificationRouter.instance()
  #router.add_notifier(UserNotification::Channel::TEXT, UserNotification::SmsUserNotifier.new)
  router.add_notifier(UserNotification::Channel::EMAIL, UserNotification::ElasticEmailEmailUserNotifier.new)
  #router.add_notifier(UserNotification::Channel::APP, UserNotification::AppUserNotifier.new)

  router.enable_notifications({ 
                                UserNotification::Notification::APP_LINK => true, 
                                UserNotification::Notification::USER_INVITE => true, 
                                UserNotification::Notification::USER_WELCOME => true,
                                UserNotification::Notification::SIGNATURE_CONFIRMATION => true
                                })
  #TWITTER STUFF
  TWITTER_CONSUMER_KEY = Settings.twitter_app_key
  TWITTER_CONSUMER_SECRET = Settings.twitter_app_secret

  FACEBOOK_APP_ID = Settings.facebook_app_id
  FACEBOOK_APP_SECRET = Settings.facebook_secret_key

  #NATION BUILDER SETTINGS
  NB_NATION_NAME = "rva", 
  NB_CLIENT_ID = "fca8f40ae0dba84cb81e8f4975b4759b4debeb4424c54e204105096a36d50a86",
  NB_CLIENT_SECRET = "22760ba29c759804929487f4fa935ac7744aa698700398a622fdb1d4edc0af14",
  NB_CLIENT_ACCESS_TOKEN = "ce97fd95b4a8a3b2003c00f5c30ccdcdb0710486509ea2b8acac0fd7f2336a2c",
  NB_CLIENT_REDIRECT_URL = "http://www.snaptivist.org/oauth_callback"

  config.paperclip_defaults = {
  :storage => :s3,
  :s3_credentials => {
    :bucket => "snaptivist-staging",
    :access_key_id => "AKIAIKSNRNLLIFLI7AMA",
    :secret_access_key => "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"
  }
}
end
