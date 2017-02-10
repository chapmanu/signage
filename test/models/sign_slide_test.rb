require 'test_helper'

class SignSlideTest < ActiveSupport::TestCase
  test "expects all sign slides awaiting approval" do
    # Arrange
    sign = signs(:build_team_area)
    slide_awaiting_approval = slides(:awaiting_approval)
    slide_not_awaiting_approval = slides(:expired)
    slide_without_stop_date = slides(:without_stop)
    sign_owner = users(:sign_owner)

    sign.owners << sign_owner
    sign.slides << slide_awaiting_approval
    sign.slides << slide_not_awaiting_approval
    sign.slides << slide_without_stop_date
    sign.save!

    # Assume
    assert_equal 1, slide_awaiting_approval.sign_slides.count
    assert_equal 1, slide_not_awaiting_approval.sign_slides.count
    assert_equal 1, slide_without_stop_date.sign_slides.count

    # Act
    sign_slides = SignSlide.awaiting_approval

    # Assert
    assert_includes sign_slides, slide_awaiting_approval.sign_slides.first
    assert_not_includes sign_slides, slide_not_awaiting_approval.sign_slides.first
    assert_includes sign_slides, slide_without_stop_date.sign_slides.first
  end

  test "expects one sign slide to be awaiting approval for sign owner" do
    # Arrange
    sign = signs(:build_team_area)
    slide_awaiting_approval = slides(:awaiting_approval)
    slide_not_awaiting_approval = slides(:expired)
    sign_owner = users(:sign_owner)

    sign.owners << sign_owner
    sign.slides << slide_awaiting_approval
    sign.slides << slide_not_awaiting_approval
    sign.save!

    # Assume
    assert_equal 1, slide_awaiting_approval.sign_slides.count
    assert_equal 1, slide_not_awaiting_approval.sign_slides.count

    # Act
    sign_slides = SignSlide.awaiting_approval_by_sign_owner(sign_owner)

    # Assert
    assert_includes sign_slides, slide_awaiting_approval.sign_slides.first
    assert_not_includes sign_slides, slide_not_awaiting_approval.sign_slides.first
  end

  test "expect no sign slides to be awaiting approval for non owner" do
    # Arrange
    sign = signs(:build_team_area)
    slide_awaiting_approval = slides(:awaiting_approval)
    slide_not_awaiting_approval = slides(:expired)

    sign.owners << users(:sign_owner)
    sign.slides << slide_awaiting_approval
    sign.slides << slide_not_awaiting_approval
    sign.save!

    # Assume
    assert_equal 1, slide_awaiting_approval.sign_slides.count
    assert_equal 1, slide_not_awaiting_approval.sign_slides.count

    # Act
    sign_slides = SignSlide.awaiting_approval_by_sign_owner(users(:non_sign_owner))

    # Assert
    assert_not_includes sign_slides, slide_awaiting_approval.sign_slides.first
    assert_not_includes sign_slides, slide_not_awaiting_approval.sign_slides.first
  end
end
