require 'test_helper'

class SlidesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @slide = slides(:one)
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
      post :create, slide: { background: @slide.background, background_sizing: @slide.background_sizing, background_type: @slide.background_type, content: @slide.content, datetime: @slide.datetime, duration: @slide.duration, foreground: @slide.foreground, foreground_sizing: @slide.foreground_sizing, foreground_type: @slide.foreground_type, heading: @slide.heading, location: @slide.location, menu_name: @slide.menu_name, name: @slide.name, organizer: @slide.organizer, organizer_id: @slide.organizer_id, subheading: @slide.subheading, template: @slide.template, sign_ids: [Sign.first.id] }
    end

    assert_redirected_to slide_path(assigns(:slide))
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

  test "should destroy slide" do
    assert_difference('Slide.count', -1) do
      delete :destroy, id: @slide
    end

    assert_redirected_to slides_path
  end
end
