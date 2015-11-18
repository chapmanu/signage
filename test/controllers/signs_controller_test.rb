require 'test_helper'

class SignsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @sign = signs(:one)
    sign_in users(:one)
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

  test "should destroy sign" do
    assert_difference('Sign.count', -1) do
      delete :destroy, id: @sign
    end

    assert_redirected_to signs_path
  end

  test "should add a user" do
    length = @sign.users.length
    post :add_user, id: @sign, format: :js, user_id: users(:one).id
    assert_equal length + 1, @sign.users.count
  end

  test 'should remove a user' do
    @sign.add_user(users(:one))
    length = @sign.users.length
    delete :remove_user, id: @sign, format: :js, user_id: users(:one).id
    assert_equal length - 1, @sign.users.count
  end
end
