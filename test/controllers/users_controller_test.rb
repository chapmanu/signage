require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  setup do
    @user = users(:one)
    sign_in users(:super_admin)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: { email: 'whittywillaby@gmail.com', role: 'super_admin' }
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user
    assert_response :success
  end

  test "should update user" do
    patch :update, id: @user, user: { email: @user.email, role: 'super_admin' }
    assert_equal 'super_admin', @user.reload.role
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to users_path
  end

  test "should lookup user from chapman identities" do
    VCR.use_cassette(:lookup_kerr105) do
      get :lookup, username: 'kerr105'
    end
    data = JSON.parse(response.body)
    assert_equal 'kerr105@mail.chapman.edu', data['email']
    assert_equal 'James', data['first_name']
    assert_equal 'Kerr', data['last_name']
  end
end
