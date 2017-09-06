require 'simplecov'
SimpleCov.start 'rails' unless ENV['NO_COVERAGE']

ENV['RAILS_ENV'] ||= 'test'
Dir[Rails.root.join("test/support/**/*")].each { |f| require f }
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/mock'
require 'webmock/minitest'
require 'vcr'
require 'capybara/poltergeist'
require 'minitest/rails/capybara'
require 'public_activity/testing'
require 'minitest/pride'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, {
    url_blacklist: ["http://use.typekit.net", "https://use.typekit.net"]
  })
end
Capybara.javascript_driver = :poltergeist
Capybara.default_max_wait_time = 10


class ActiveSupport::TestCase
  fixtures :all
  include MockPublicSafetyFeed
end

class ActionController::TestCase
  include Devise::TestHelpers
end

class Capybara::Rails::TestCase
  include IntegrationHelpers
end

VCR.configure do |config|
  config.cassette_library_dir = "test/vcr_cassettes"
  config.ignore_localhost = true
  config.hook_into :webmock
end

PublicActivity.enabled = true
