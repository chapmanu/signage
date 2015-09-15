require 'test_helper'

class CreateNewDeviceTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Warden::Test::Helpers
  Warden.test_mode!

  test "createing a new device" do
    login_as(users(:one), scope: :user)
    visit admin_path
    click_link 'manage-devices-link'
    click_link 'new-device-link'
    fill_in 'device_name',     with: 'Talk Nerdy to Me'
    fill_in 'device_location', with: 'Nice'
    select  'Default',         from: 'device_template'
    click_button 'Create Device'
    assert page.has_content?('Device was successfully created.')
    click_link 'add-slide-link'
    assert page.has_content?('Back to Device')
    assert_equal '/slides/new', current_path
  end
end
