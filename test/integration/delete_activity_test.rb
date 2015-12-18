require 'test_helper'

class DeleteActivityTest < ActionDispatch::IntegrationTest
  
  setup do
    sign_in users(:james)
  end

  teardown do
    sign_out
  end

  test "creating and deleting a slide" do
    assert_difference 'PublicActivity::Activity.count', 2 do
      post slides_path, slide: { menu_name: 'Yo', template: 'standard' }
      delete slide_path(Slide.last)
    end
    get notifications_index_path
    assert_response :success
  end

  test "updating and deleteing a slide" do
    assert_difference 'PublicActivity::Activity.count', 2 do
      put slide_path(slides(:one)), slide: { menu_name: 'updated', template: 'standard' }
      delete slide_path(slides(:one))
    end
    get notifications_index_path
    assert_response :success
  end

  test "creating and deleting a sign" do
    assert_difference 'PublicActivity::Activity.count', 2 do
      post signs_path, sign: { name: 'created a sign' }
      delete sign_path(Sign.last)
    end
    get notifications_index_path
    assert_response :success
  end

  test "updating and deleting a sign" do
    assert_difference 'PublicActivity::Activity.count', 2 do
      put sign_path(signs(:one)), sign: { name: 'updated a sign' }
      delete sign_path(signs(:one))
    end
    get notifications_index_path
    assert_response :success
  end
end
