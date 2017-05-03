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
    assert_equal 2, slide_not_awaiting_approval.sign_slides.count
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
    assert_equal 2, slide_not_awaiting_approval.sign_slides.count

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
    assert_equal 2, slide_not_awaiting_approval.sign_slides.count

    # Act
    sign_slides = SignSlide.awaiting_approval_by_sign_owner(users(:non_sign_owner))

    # Assert
    assert_not_includes sign_slides, slide_awaiting_approval.sign_slides.first
    assert_not_includes sign_slides, slide_not_awaiting_approval.sign_slides.first
  end

  test "expects sign owners notifications to be ordered by stop_on field" do
    # Arrange
    sign = signs(:build_team_area)
    slide_expires_tomorrow = slides(:awaiting_approval)
    slide_expires_in_week = slide_expires_tomorrow.dup
    slide_without_stop_date = slides(:without_stop)
    expired_slide = slides(:expired)
    sign_owner = users(:sign_owner)

    slide_expires_tomorrow.update(stop_on: Time.zone.now + 1.day)
    slide_expires_in_week.update(stop_on: Time.zone.now + 1.week)

    sign.owners << sign_owner
    sign.slides << slide_expires_tomorrow
    sign.slides << slide_expires_in_week
    sign.slides << slide_without_stop_date
    sign.slides << expired_slide
    sign.save!

    # Assume
    assert_equal 4, sign.slides.count
    assert_includes sign.owners, sign_owner
    expected_sign_slides_order = [slide_expires_tomorrow.sign_slides.first,
                                  slide_expires_in_week.sign_slides.first,
                                  slide_without_stop_date.sign_slides.first]

    # Act
    sign_slides = SignSlide.awaiting_approval_by_sign_owner(sign_owner).to_a

    # Assert
    assert_equal expected_sign_slides_order, sign_slides
  end

  test "expects unexpired to filter expired slides" do
    #Arrange
    #sign_slides fixture associates expired slide with default sign
    sign = signs(:default)
    sign.save!

    #Assert
    assert_includes sign.sign_slides, sign_slides(:expired)
    assert_not_includes sign.sign_slides.unexpired, sign_slides(:expired)

  end
end
