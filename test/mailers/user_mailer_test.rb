require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  test "sign_slide_request" do
    signs(:one).owners << users(:ross)
    mail = UserMailer.sign_slide_request(sign_slide: sign_slides(:one), requestor: users(:james))
    assert_equal "Play Slide Request: MyString", mail.subject
    assert_equal ["loehner@chapman.edu"], mail.to
    assert_match "requesting that their slide", mail.body.encoded
  end

  test "sign_slide_approved" do
    slides(:one).owners << users(:ross)
    signs(:one).owners << users(:james)
    mail = UserMailer.sign_slide_approved(sign_slide: sign_slides(:one), approver: users(:james))
    assert_equal "Slide Approved to Play on sign_one", mail.subject
    assert_equal ["loehner@chapman.edu"], mail.to
    assert_match "was approved by James", mail.body.encoded
  end

  test "sign_slide_rejected" do
    slides(:one).owners << users(:ross)
    signs(:one).owners << users(:james)
    mail = UserMailer.sign_slide_rejected(sign_slide: sign_slides(:one), rejector: users(:james))
    assert_equal "Slide Rejected to Play on sign_one", mail.subject
    assert_equal ["loehner@chapman.edu"], mail.to
    assert_match /James .* chose not to display/, mail.body.encoded
  end

  test "sign_add_owner" do
    mail = UserMailer.sign_add_owner(item: signs(:one), user: users(:ross))
    assert_equal "You've been added as an owner of the sign_one sign", mail.subject
    assert_equal ["loehner@chapman.edu"], mail.to
    assert_match /Ross.* added as an owner.* sign/m, mail.body.encoded
  end

  test "sign_remove_owner" do
    mail = UserMailer.sign_remove_owner(item: signs(:one), user: users(:ross))
    assert_equal "You've been removed as an owner of the sign_one sign", mail.subject
    assert_equal ["loehner@chapman.edu"], mail.to
    assert_match /Ross.* removed as an owner.* sign/m, mail.body.encoded
  end

  test "slide_add_owner" do
    mail = UserMailer.slide_add_owner(item: slides(:one), user: users(:ross))
    assert_equal "You've been added as an owner of the MyString slide", mail.subject
    assert_equal ["loehner@chapman.edu"], mail.to
    assert_match /Ross.* added as an owner.* slide/m, mail.body.encoded
  end

  test "slide_remove_owner" do
    mail = UserMailer.slide_remove_owner(item: slides(:one), user: users(:ross))
    assert_equal "You've been removed as an owner of the MyString slide", mail.subject
    assert_equal ["loehner@chapman.edu"], mail.to
    assert_match /Ross.* removed as an owner.* slide/m, mail.body.encoded
  end
end
