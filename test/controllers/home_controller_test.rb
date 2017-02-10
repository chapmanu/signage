require 'test_helper'

class HomeControllerTest < ActionController::TestCase

  setup do
    sign_in users(:two)
  end

  def setup_sign_owner_signs_and_slides
    sign = signs(:build_team_area)
    sign.owners << users(:sign_owner)
    sign.slides << slides(:awaiting_approval)
    sign.slides << slides(:without_stop)
    sign.slides << slides(:expired)
    sign.save!
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "expects index to show all unexpired notifications to super admin" do
    # Arrange
    super_admin = users(:super_admin)
    sign_owner = users(:sign_owner)
    sign = signs(:build_team_area)
    setup_sign_owner_signs_and_slides

    # Assume super_admin does not own signs with slides awaiting approval.
    assert_equal 3, sign.slides.count
    assert_equal 0, super_admin.signs.count
    assert_includes sign.owners, sign_owner, "sign_owner should own build team area sign."

    # Includes two sign_slide fixtures.
    assert_equal 4, SignSlide.awaiting_approval.count

    # Act
    sign_in super_admin
    get :index

    # Assert
    assert_select "div.unapproved-sign-slide", 4
  end

  test "expects index to show all unexpired notifications to sign owner" do
    # Arrange
    sign_owner = users(:sign_owner)
    sign = signs(:build_team_area)
    setup_sign_owner_signs_and_slides

    # Assume
    assert_includes sign.owners, sign_owner, "sign_owner should own build team area sign."

    # Act
    sign_in sign_owner
    get :index

    # Assert
    assert_select "div.unapproved-sign-slide", 2
  end
end
