require 'test_helper'

class EmergencyPermissionsTest < Capybara::Rails::TestCase

  test "can view when super_admin" do
    # Arrange
    # sign_in users(:super_admin)
    
    # ldap_data = {"username": "super_admin", "email": users(:super_admin).email}
    # p ldap_data.to_s
    
    ldap_data = '{"username": "super_admin", "email": "super_admin@chapman.edu"}'
    stub_request(:any, "https://notify.bugsnag.com/")
    stub_request(:any, "https://chapmanedu%2Fadbind400:yedvodX4lZBCOeqmMcBm@webfarm.chapman.edu/RoleIdentity/api/Role/super_admin").to_return(body: ldap_data)

    Net::LDAP.stub_any_instance(:bind, true) do
      visit new_user_session_path
      fill_in 'Chapman Username', with: users(:super_admin).email
      fill_in 'Password', with: "anything"
      click_button 'Log in'
    end
    
    p page.body

    # Act
    visit emergencies_path

    # Assert
    assert_equal 200, page.status_code
    assert !(page.body.include? "You need to sign in"), "expects user to be signed in"

  end

  test "cannot view when normal user" do
    skip
    sign_in users(:james)
    visit emergencies_path
    assert_equal 403, page.status_code
  end
end