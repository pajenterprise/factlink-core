FactlinkUI::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Error reporting
  config.middleware.use ExceptionNotifier,
    :email_prefix => "[FL##{Rails.env}] ",
    :sender_address => %{"#{Rails.env} - FL - Bug notifier" <bugs@factlink.com>},
    :exception_recipients => %w{bugs@factlink.com}

  # The staging environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = "X-Sendfile"

  # For nginx:
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in staging
  # config.cache_store = :mem_cache_store

  # Disable Rails's static asset server
  # In staging, Apache or nginx will already do this
  config.serve_static_assets = false

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default_url_options = { :host => "staging.factlink.com" }

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

end

ActionMailer::Base.smtp_settings = {
  :address => 'mail.factlink.com',
  :port => 25,
  :domain => 'factlink.com',
  :authentication => :plain,
  :user_name => 'noreply',
  :password => '@H-cw8w)6l8.nP',
  :openssl_verify_mode => 'none'
}