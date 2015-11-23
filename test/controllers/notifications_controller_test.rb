require 'test_helper'

class NotificationsControllerTest < ActionController::TestCase

  setup do
    sign_in users(:two)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should assign unapproved sign slides" do
    users(:two).add_sign(signs(:one))
    signs(:one).add_slide(slides(:two))
    assert_equal 1, users(:two).signs.count

    get :index

    assert_equal 2, assigns(:unapproved_sign_slides).length
  end
end
