require 'test_helper'

class DevicesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @device = devices(:one)
    sign_in users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:devices)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create device" do
    assert_difference('Device.count') do
      post :create, device: { emergency: @device.emergency, emergency_detail: @device.emergency_detail, location: @device.location, name: @device.name, template: @device.template, updated_at: @device.updated_at }
    end

    assert_redirected_to assigns(:device)
  end

  test "should show device" do
    get :show, id: @device
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @device
    assert_response :success
  end

  test "should update device" do
    patch :update, id: @device, device: { emergency: @device.emergency, emergency_detail: @device.emergency_detail, location: @device.location, name: @device.name, template: @device.template, updated_at: @device.updated_at }
    assert_redirected_to assigns(:device)
  end

  test "should destroy device" do
    assert_difference('Device.count', -1) do
      delete :destroy, id: @device
    end

    assert_redirected_to devices_path
  end

  test "should add a user" do
    length = @device.users.length
    post :add_user, id: @device, format: :js, user_id: users(:one).id
    assert_equal length + 1, @device.users.count
  end

  test 'should remove a user' do
    @device.add_user(users(:one))
    length = @device.users.length
    delete :remove_user, id: @device, format: :js, user_id: users(:one).id
    assert_equal length - 1, @device.users.count
  end
end
