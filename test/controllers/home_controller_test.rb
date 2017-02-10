require 'test_helper'

class HomeControllerTest < ActionController::TestCase

  setup do
    sign_in users(:two)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should assign unapproved sign slides" do
    users(:two).signs << signs(:one)
    signs(:one).slides << slides(:two)
    assert_equal 1, users(:two).signs.count

    get :index

    assert_equal 2, assigns(:unapproved_sign_slides).length
  end

  test "expects index to show all unexpired notifications to super admin" do
    # Arrange
    super_admin = users(:super_admin)
    sign_owner = users(:sign_owner)
    sign = signs(:build_team_area)
    sign.owners << sign_owner
    sign.slides << slides(:awaiting_approval)
    sign.slides << slides(:expired)
    sign.save!

    # Assume super_admin does not own signs with slides awaiting approval.
    assert_equal 2, sign.slides.count
    assert_equal 1, SignSlide.awaiting_approval.count
    assert_equal 0, super_admin.signs.count
    assert_includes sign.owners, sign_owner, "sign_owner should own build team area sign."

    # Act
    sign_in super_admin
    get :index

    # Assert
    assert_select "div.unapproved-sign-slide", 1
  end
end
