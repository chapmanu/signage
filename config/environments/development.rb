Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # User letter_opener_web to view emails in browser at /letter_opener
  config.action_mailer.delivery_method = :letter_opener_web

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  #
  # Switch User
  #
  # Skip authentication for SkipUserController: http://stackoverflow.com/a/16623868/6763239
  config.to_prepare do
    SwitchUserController.skip_before_filter :authenticate_user!
  end

  # Dev-specific configuration replaces initializers/switch_user.rb
  # Source: https://github.com/flyerhzm/switch_user/issues/35
  config.after_initialize do
    SwitchUser.setup do |config|
      # provider may be :devise, :authlogic, :clearance, :restful_authentication, :sorcery, or :session
      config.provider = :devise

      # available_users_names is a hash,
      # keys in this hash should match a key in the available_users hash
      # value is the column name which will be displayed in select box
      config.available_users_names = { :user => :full_name }
    end
  end

  # Public Safety alert configuration.
  config.x.public_safety.feed = 'https://imposter.chapman.edu/rave.rss'
end

Rails.application.routes.default_url_options[:host] = 'localhost:3000'
