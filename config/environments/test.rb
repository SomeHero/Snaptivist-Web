SnaptivistWeb::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The test environment is used exclusively to run your application's
  # test suite. You never need to work with it otherwise. Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs. Don't rely on the data there!
  config.cache_classes = true

  # Configure static asset server for tests with Cache-Control for performance
  config.serve_static_assets = true
  config.static_cache_control = "public, max-age=3600"

  # Log error messages when you accidentally call methods on nil
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment
  config.action_controller.allow_forgery_protection    = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Raise exception on mass assignment protection for Active Record models
  #config.active_record.mass_assignment_sanitizer = :strict

  # Print deprecation notices to the stderr
  config.active_support.deprecation = :stderr

  ###########################################################################################################
  # Application logging
  #

  # Log detail
  config.log_level = :debug

  config.eager_load = false
  
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
                                UserNotification::Notification::DONATION_REMINDER => true
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
    :bucket => "snaptivist-test",
    :access_key_id => "AKIAIKSNRNLLIFLI7AMA",
    :secret_access_key => "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"
  }
}
end
