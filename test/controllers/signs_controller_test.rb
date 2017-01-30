require 'test_helper'

class SignsControllerTest < ActionController::TestCase
  include OwnableControllerTest

  let(:user) { users(:james) }

  setup do
    @sign = @owned_object = signs(:one)
    @sign.owners << user
    sign_in user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:signs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sign" do
    assert_difference('Sign.count') do
      post :create, sign: { emergency: @sign.emergency, emergency_detail: @sign.emergency_detail, location: @sign.location, name: @sign.name, template: @sign.template, updated_at: @sign.updated_at }
    end

    assert_redirected_to assigns(:sign)
  end

  test "should show sign" do
    get :show, id: @sign
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sign
    assert_response :success
  end

  test "should update sign" do
    patch :update, id: @sign, sign: { emergency: @sign.emergency, emergency_detail: @sign.emergency_detail, location: @sign.location, name: @sign.name, template: @sign.template, updated_at: @sign.updated_at }
    assert_redirected_to assigns(:sign)
  end

  test "should reorder sign_slides" do
    signs(:one).slides << slides(:one)
    signs(:one).slides << slides(:two)
    before_order = signs(:one).sign_slides.order(:order).ids

    post :order, id: @sign, sign_slide_ids: before_order.reverse
    assert_equal before_order.reverse, assigns(:sign).sign_slides.order(:order).ids
  end

  test "reorder should touch sign updated at" do
    post :order, id: @sign, sign_slide_ids: []
    assert @sign.updated_at < assigns(:sign).updated_at
  end

  test "remove a slide from the sign" do
    @sign.slides.clear
    @sign.slides << slides(:one)
    assert_equal 1, @sign.slides.count
    delete :remove_slide, id: @sign, slide_id: slides(:one).id, format: :js
    assert_equal 0, @sign.slides.count
  end

  test "creating a slide produces 1 new activity record" do
    assert_difference('PublicActivity::Activity.count', 1) do
      post :create, sign: { emergency: @sign.emergency, emergency_detail: @sign.emergency_detail, location: @sign.location, name: @sign.name, template: @sign.template, updated_at: @sign.updated_at }
    end
  end

  test "updating a sign produces 1 new activity record" do
    assert_difference('PublicActivity::Activity.count', 1) do
      patch :update, id: @sign, sign: { menu_name: 'Show me on the activity page!'}
    end
  end

  test "destorying a slide produces 1 new activity record" do
    assert_difference('PublicActivity::Activity.count', 1) do
      patch :destroy, id: @sign, sign: { menu_name: 'Show me on the activity page!'}
    end
  end

  test "should destroy sign" do
    assert_difference('Sign.count', -1) do
      delete :destroy, id: @sign
    end

    assert_redirected_to signs_path
  end

  test "should play sign" do
    sign_out @sign.owners.first
    get :play, id: @sign
    assert_response :success
  end

  test "expects signs to be centered properly when played" do
    # Issue 156: https://github.com/chapmanu/signage/issues/156
    sign_out @sign.owners.first
    get :play, id: @sign
    assert_response :success

    # Assert body text starts with expected content.
    assert_select 'body' do |elements|
      body_content = elements.first.content.strip
      expected_content = 'MyString'
      assert_equal body_content[0...expected_content.length], expected_content
    end
  end

  test "should poll sign for updates" do
    # Poll endpoint should not require auth. Authorization had been enabled leading to 403
    # responses in production that were blocking updates.
    sign_out @sign.owners.first
    xhr :get, :poll, id: @sign, sign: { updated_at: Time.zone.now }
    assert_response :success
  end

  test "expects sign to be played even when it is private" do
    # Issue 160: https://github.com/chapmanu/signage/issues/160
    # Arrange
    private_sign = signs(:private)

    # Assume
    assert private_sign.owners.empty?
    assert private_sign.private?

    # Act
    get :play, id: private_sign

    # Assert
    assert_response :success
  end
end
