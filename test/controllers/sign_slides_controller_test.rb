require 'test_helper'

class SignSlidesControllerTest < ActionController::TestCase

  setup do
    @sign_slide = sign_slides(:one)
    sign_in users(:two)
  end

  test "approving a sign slide" do
    assert !@sign_slide.approved?, 'This slide is already approved'
    post :approve, id: @sign_slide, format: :js
    assert @sign_slide.reload.approved?, "It did not approve the slide"
  end

  test "rejecting a sign slide deletes it" do
    delete :reject, id: @sign_slide, format: :js
    assert_not SignSlide.exists?(@sign_slide.id), "Sign slide was not destroyed"
  end
end
