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
end
