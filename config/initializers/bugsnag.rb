Bugsnag.configure do |config|
    config.notify_release_stages = ["production", "staging"]
end

unless Rails.env.development? || Rails.env.test?
  Bugsnag.configure do |config|
    config.api_key = Rails.application.secrets.bugsnag_api_key
  end
end
