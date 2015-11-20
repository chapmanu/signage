require 'test_helper'

class NotificationsControllerTest < ActionController::TestCase

  setup do
    sign_in users(:two)
  end

  test "should get index" do
    get :index
    assert_response :success
  end
end
