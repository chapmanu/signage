require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  test "sign_slide_request" do
    signs(:one).owners << users(:ross)
    mail = UserMailer.sign_slide_request(sign_slide: sign_slides(:one), requestor: users(:james))
    assert_equal "Play Slide Request: MyString", mail.subject
    assert_equal ["loehner@chapman.edu"], mail.to
    assert_equal ["no-reply@mail.chapman.edu"], mail.from
    assert_match "requesting that their slide", mail.body.encoded
  end

  test "sign_slide_approved" do
    slides(:one).owners << users(:ross)
    signs(:one).owners << users(:james)
    mail = UserMailer.sign_slide_approved(sign_slide: sign_slides(:one), approver: users(:james))
    assert_equal "Slide Approved to Play on sign_one", mail.subject
    assert_equal ["loehner@chapman.edu"], mail.to
    assert_equal ["no-reply@mail.chapman.edu"], mail.from
    assert_match "was approved by James", mail.body.encoded
  end
end
