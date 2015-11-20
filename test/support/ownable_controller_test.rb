module OwnableControllerTest
  def test_should_add_an_owner
    length = @owned_object.users.length
    post :add_owner, id: @owned_object, format: :js, user_id: users(:one).id
    assert_equal length + 1, @owned_object.users.count
  end

  def test_should_remove_an_owner
    @owned_object.add_user(users(:one))
    length = @owned_object.users.length
    delete :remove_owner, id: @owned_object, format: :js, user_id: users(:one).id
    assert_equal length - 1, @owned_object.users.count
  end
end