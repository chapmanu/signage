require 'test_helper'

class SlidesControllerTest < ActionController::TestCase
  include OwnableControllerTest

  setup do
    @slide = @owned_object = slides(:standard)
    sign_in users(:non_sign_owner)
    @slide.owners << users(:non_sign_owner)
    ActionMailer::Base.deliveries.clear
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
      post :create, slide: { background: @slide.background, background_sizing: @slide.background_sizing, background_type: @slide.background_type, content: @slide.content, datetime: @slide.datetime, duration: @slide.duration, foreground: @slide.foreground, foreground_sizing: @slide.foreground_sizing, foreground_type: @slide.foreground_type, heading: @slide.heading, location: @slide.location, menu_name: @slide.menu_name, name: @slide.name, subheading: @slide.subheading, template: @slide.template }
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
    patch :update, id: @slide, slide: { background: @slide.background, background_sizing: @slide.background_sizing, background_type: @slide.background_type, content: @slide.content, datetime: @slide.datetime, duration: @slide.duration, foreground: @slide.foreground, foreground_sizing: @slide.foreground_sizing, foreground_type: @slide.foreground_type, heading: @slide.heading, location: @slide.location, menu_name: @slide.menu_name, name: @slide.name, subheading: @slide.subheading, template: @slide.template }
    assert_redirected_to slide_path(assigns(:slide))
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
      patch :create, slide: { background: @slide.background, background_sizing: @slide.background_sizing, background_type: @slide.background_type, content: @slide.content, datetime: @slide.datetime, duration: @slide.duration, foreground: @slide.foreground, foreground_sizing: @slide.foreground_sizing, foreground_type: @slide.foreground_type, heading: @slide.heading, location: @slide.location, menu_name: @slide.menu_name, name: @slide.name, subheading: @slide.subheading, template: @slide.template }
    end
  end

  test "destroying a slide produces 1 new activity record" do
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

  test "expects scheduled items to be ignored when updating a slide draft" do
    # This was causing an error. Scheduled items will still be updated upon submit.
    # For details, see: https://github.com/chapmanu/signage/issues/147
    patch :draft, id: @slide, slide: { scheduled_items_attributes: [ { date: 'Right Now'} ] }

    assert_response :success
    draft = @slide.find_or_create_draft
    assert_equal 0, draft.scheduled_items.length
  end

  test "expects sign owner and not super admin to be emailed when slide sent to sign" do
    # Arrange
    super_admin = users(:super_admin)
    sign_owner = users(:sign_owner)
    slide_owner = users(:non_sign_owner)
    sign = signs(:build_team_area)
    slide = slides(:awaiting_approval)

    sign.owners << sign_owner
    slide_owner.slides << slide
    super_admin_notifications_before = super_admin.sign_slides_awaiting_approval.count
    sign_owner_notifications_before = sign_owner.sign_slides_awaiting_approval.count

    # Assume
    assert_equal 0, ActionMailer::Base.deliveries.length

    # Act
    sign_in slide_owner
    patch :update, id: slide, slide: { sign_ids: [sign.id] }
    emails_sent = ActionMailer::Base.deliveries

    # Assert
    assert_redirected_to slide_path(assigns(:slide))
    assert_equal super_admin_notifications_before + 1, super_admin.sign_slides_awaiting_approval.count
    assert_equal sign_owner_notifications_before + 1, sign_owner.sign_slides_awaiting_approval.count
    assert_equal 1, emails_sent.length
    assert_equal [sign_owner.email], emails_sent.first.to
  end

  test "updates slide orientation to horizontal when updating slide template from vertical capable template to non-vertical capable template" do
    sign_in users(:super_admin)
    slide = slides(:social_feed_vertical)
    assert_equal "vertical", slide.orientation

    patch :update, id: slide, slide: { template: "standard"}

    assert_equal "horizontal", slide.reload.orientation
  end

  test "vertical capable template can update orientation to vertical when updating slide orientation" do
    sign_in users(:super_admin)
    slide = slides(:social_feed_horizontal)
    assert_equal "horizontal", slide.orientation

    patch :update, id: slide, slide: { orientation: "vertical", template: slide.template }

    assert_equal "vertical", slide.reload.orientation
  end

  test "non-vertical capable template cannot update orientation to vertical when updating slide orientation" do
    sign_in users(:super_admin)
    slide = slides(:standard)
    assert_equal "horizontal", slide.orientation

    patch :update, id: slide, slide: { orientation: "vertical", template: slide.template }

    assert_equal "horizontal", slide.reload.orientation
  end

  test "assert that `controls muted` attribute is present on slides with foreground_type: video" do
    # Arrange
    super_admin = users(:super_admin)
    slide = slides(:video_foreground)
    assert_equal "video", slide.foreground_type

    # Assume

    # Act
    get :preview, id: slide
    assert_response :success

    # Assert
    assert_select "video[controls]"
    assert_select "video[muted]"
  end

  test "assert that `controls muted` attribute is present on slides with background_type: video" do
    # Arrange
    super_admin = users(:super_admin)
    slide = slides(:video_background)
    assert_equal "video", slide.background_type

    # Assume

    # Act
    get :preview, id: slide
    assert_response :success

    # Assert
    assert_select "video[controls]"
    assert_select "video[muted]"
  end
end