require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Signage
  class Application < Rails::Application
    config.asset_url = 'http://www2.chapman.edu'
    config.autoload_paths << Rails.root.join('lib')

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    # Link Action Mailer to the Chapman SMTP server
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.perform_deliveries = true
    config.action_mailer.smtp_settings = {
      address:              'smtp.chapman.edu',
      port:                 25
    }
    config.action_mailer.raise_delivery_errors = true

    # Custom Devise Layout for Sessions
    config.to_prepare do
      Devise::SessionsController.layout "admin"
    end

    # Override the rails field errors wrappers
    config.action_view.field_error_proc = Proc.new { |html_tag, instance|
      html_tag
    }

    config.generators do |g|
      g.controller_specs false
      g.view_specs false
      g.helper_specs false
    end

    # Campus alert configuration
    config.x.campus_alert.feed = 'https://www.getrave.com/rss/chapman/channel1'
  end
end
