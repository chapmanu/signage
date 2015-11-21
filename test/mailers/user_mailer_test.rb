require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "sign_slide_request" do
    mail = UserMailer.sign_slide_request('anything for now')
    assert_equal "Sign slide request", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
