unless Rails.env.development? || Rails.env.test?
  Bugsnag.configure do |config|
    config.api_key = "a6d7d09c72fcc4d57ed110a2c1c5a834"
  end
end
