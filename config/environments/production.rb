SnaptivistWeb::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = false

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = true

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to nil and saved in location specified by config.assets.prefix
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )

  config.assets.precompile += [
    'libs/modernizr-2.6.2.js',
    'active_admin.js',
    'clients.js',
    'dashboard.js',
    'petitions.js',
    'phonecampaigns.js',
    'polls.js',
    'widgets.js',
    'moment.js',
    'ui-bootstrap-0.3.0.js',
    'layouts/layout1.css',
    'layouts/layout2.css',
    'layouts/layout2-responsive.css',
    'themes/layout1_standard.css',
    'themes/layout2_standard.css',
    'active_admin.css',
    'active_admin/print.css',
    'clients.css',
    'petitions.css',
    'phonecampaigns.css',
    'polls.css'
  ]
  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  # config.active_record.auto_explain_threshold_in_seconds = 0.5
    
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
                                UserNotification::Notification::SIGNATURE_CONFIRMATION => true,
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
    :bucket => "snaptivist",
    :access_key_id => "AKIAIKSNRNLLIFLI7AMA",
    :secret_access_key => "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"
  }
}

ENV["REDISTOGO_URL"] = 'redis://redistogo:346b27529b87e240da71e294ed319233@albacore.redistogo.com:9574/'

end
