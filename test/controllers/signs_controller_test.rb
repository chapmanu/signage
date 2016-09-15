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

  test "should poll sign for update" do
    sign_out @sign.owners.first
    xhr :get, :poll, id: @sign
    assert_response :success
  end
end

