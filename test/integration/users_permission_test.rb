require 'test_helper'

class UsersPermissionTest < Capybara::Rails::TestCase

  test "can view when super_admin" do
    sign_in users(:super_admin)
    visit users_path
    assert_equal 200, page.status_code
  end

  test "cannot view when normal user" do
    sign_in users(:james)
    visit users_path
    assert_equal 403, page.status_code
  end
end