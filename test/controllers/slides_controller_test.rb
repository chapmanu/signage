require 'test_helper'

class SlidesControllerTest < ActionController::TestCase
  include OwnableControllerTest

  setup do
    @slide = @owned_object = slides(:one)
    sign_in users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:slides)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create slide" do
    assert_difference('Slide.count') do
      post :create, slide: { background: @slide.background, background_sizing: @slide.background_sizing, background_type: @slide.background_type, content: @slide.content, datetime: @slide.datetime, duration: @slide.duration, foreground: @slide.foreground, foreground_sizing: @slide.foreground_sizing, foreground_type: @slide.foreground_type, heading: @slide.heading, location: @slide.location, menu_name: @slide.menu_name, name: @slide.name, organizer: @slide.organizer, organizer_id: @slide.organizer_id, subheading: @slide.subheading, template: @slide.template }
    end
    assert_match /dev-screenshot/, assigns(:slide).reload.screenshot.url
    assert_redirected_to edit_slide_path(assigns(:slide))
  end

  test "should show slide" do
    get :show, id: @slide
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @slide
    assert_response :success
  end

  test "should update slide" do
    patch :update, id: @slide, slide: { background: @slide.background, background_sizing: @slide.background_sizing, background_type: @slide.background_type, content: @slide.content, datetime: @slide.datetime, duration: @slide.duration, foreground: @slide.foreground, foreground_sizing: @slide.foreground_sizing, foreground_type: @slide.foreground_type, heading: @slide.heading, location: @slide.location, menu_name: @slide.menu_name, name: @slide.name, organizer: @slide.organizer, organizer_id: @slide.organizer_id, subheading: @slide.subheading, template: @slide.template }
    assert_redirected_to slide_path(assigns(:slide))
  end

  test "should check sign slide approvals" do
    @slide.signs.clear
    users(:one).signs.clear
    sign_ids = Sign.create([{name: 'one'}, {name: 'two'}, {name: 'three'}]).map(&:id) # creating some random signs
    users(:one).signs << Sign.find(sign_ids[0]) # current_user now owns 1 of the signs

    assert_difference('ActionMailer::Base.deliveries.length', 2) do
      patch :update, id: @slide, slide: { sign_ids: sign_ids }
    end

    assert_equal 1, @slide.sign_slides.where(approved: true).count
    assert_equal 2, @slide.sign_slides.where(approved: false).count

    # When you do it again, no more emails get sent
    assert_no_difference('ActionMailer::Base.deliveries.length') do
      patch :update, id: @slide, slide: { sign_ids: sign_ids }
    end
  end

  test "took screenshot after update" do
    patch :update, id: @slide, slide: { menu_name: 'something to update'}
    assert_match /dev-screenshot/, assigns(:slide).reload.screenshot.url
  end

  test "updating a slide produces 1 new activity record" do
    assert_difference('PublicActivity::Activity.count', 1) do
      patch :update, id: @slide, slide: { menu_name: 'Show me on the activity page!'}
    end
  end

    test "creating a slide produces 1 new activity record" do
    assert_difference('PublicActivity::Activity.count', 1) do
      patch :create, slide: { background: @slide.background, background_sizing: @slide.background_sizing, background_type: @slide.background_type, content: @slide.content, datetime: @slide.datetime, duration: @slide.duration, foreground: @slide.foreground, foreground_sizing: @slide.foreground_sizing, foreground_type: @slide.foreground_type, heading: @slide.heading, location: @slide.location, menu_name: @slide.menu_name, name: @slide.name, organizer: @slide.organizer, organizer_id: @slide.organizer_id, subheading: @slide.subheading, template: @slide.template }
    end
  end

  test "destorying a slide produces 1 new activity record" do
    assert_difference('PublicActivity::Activity.count', 1) do
      delete :destroy, id: @slide
    end
  end

  test "should destroy slide" do
    assert_difference('Slide.count', -1) do
      delete :destroy, id: @slide
    end

    assert_redirected_to slides_path
  end

end
