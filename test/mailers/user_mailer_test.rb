require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  test "sign_slide_request" do
    signs(:default).owners << users(:ross)
    sign_slides(:default).slide.play_on = "2016-09-05 10:45:00"
    sign_slides(:default).slide.stop_on = "2016-09-07 10:45:00"
    mail = UserMailer.sign_slide_request(sign_slide: sign_slides(:default), requestor: users(:james))
 
    assert_equal "Play Slide Request: MyString", mail.subject
    assert_equal ["loehner@chapman.edu"], mail.to
    assert_match "requesting that their slide", mail.body.encoded

    # email should include the date range for the slide request
    assert_match (/September 5, 2016/), mail.body.encoded
    assert_match (/September 7, 2016/), mail.body.encoded
  end

  test "sign_slide_sans_message_approved" do
    slides(:standard).owners << users(:ross)
    signs(:default).owners << users(:james)
    mail = UserMailer.sign_slide_approved(sign_slide: sign_slides(:default), approver: users(:james))
    assert_equal "Slide Approved to Play on sign_one", mail.subject
    assert_equal ["loehner@chapman.edu"], mail.to
    assert_match "was approved by James", mail.body.encoded
    refute_match "James added a custom message", mail.body.encoded
  end

  test "sign_slide_sans_message_rejected" do
    slides(:standard).owners << users(:ross)
    signs(:default).owners << users(:james)
    mail = UserMailer.sign_slide_rejected(sign_slide: sign_slides(:default), rejector: users(:james))
    assert_equal "Slide Rejected to Play on sign_one", mail.subject
    assert_equal ["loehner@chapman.edu"], mail.to
    assert_match /James .* chose not to display/, mail.body.encoded
    refute_match "James added a custom message", mail.body.encoded
  end

  test "sign_slide_with_message_approved" do
    slides(:standard).owners << users(:ross)
    signs(:default).owners << users(:james)
    mail = UserMailer.sign_slide_approved(sign_slide: sign_slides(:default), approver: users(:james), message: "Arbitrary approval message")
    assert_equal "Slide Approved to Play on sign_one", mail.subject
    assert_equal ["loehner@chapman.edu"], mail.to
    assert_match "was approved by James", mail.body.encoded
    assert_match "James added a custom message", mail.body.encoded
  end

  test "sign_slide_with_message_rejected" do
    slides(:standard).owners << users(:ross)
    signs(:default).owners << users(:james)
    mail = UserMailer.sign_slide_rejected(sign_slide: sign_slides(:default), rejector: users(:james), message: "Arbitrary rejection message")
    assert_equal "Slide Rejected to Play on sign_one", mail.subject
    assert_equal ["loehner@chapman.edu"], mail.to
    assert_match /James .* chose not to display/, mail.body.encoded
    assert_match "James added a custom message", mail.body.encoded
  end

  test "sign_add_owner" do
    mail = UserMailer.sign_add_owner(item: signs(:default), user: users(:ross))
    assert_equal "You've been added as an owner of the sign_one sign", mail.subject
    assert_equal ["loehner@chapman.edu"], mail.to
    assert_match /Ross.* added as an owner.* sign/m, mail.body.encoded
  end

  test "sign_remove_owner" do
    mail = UserMailer.sign_remove_owner(item: signs(:default), user: users(:ross))
    assert_equal "You've been removed as an owner of the sign_one sign", mail.subject
    assert_equal ["loehner@chapman.edu"], mail.to
    assert_match /Ross.* removed as an owner.* sign/m, mail.body.encoded
  end

  test "slide_add_owner" do
    mail = UserMailer.slide_add_owner(item: slides(:standard), user: users(:ross))
    assert_equal "You've been added as an owner of the MyString slide", mail.subject
    assert_equal ["loehner@chapman.edu"], mail.to
    assert_match /Ross.* added as an owner.* slide/m, mail.body.encoded
  end

  test "slide_remove_owner" do
    mail = UserMailer.slide_remove_owner(item: slides(:standard), user: users(:ross))
    assert_equal "You've been removed as an owner of the MyString slide", mail.subject
    assert_equal ["loehner@chapman.edu"], mail.to
    assert_match /Ross.* removed as an owner.* slide/m, mail.body.encoded
  end
end
