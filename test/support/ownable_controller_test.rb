module OwnableControllerTest
  def test_should_add_an_owner
    length = @owned_object.users.length

    assert_difference 'ActionMailer::Base.deliveries.size' do
      post :add_owner, id: @owned_object, format: :js, user_id: users(:sign_owner).id
    end

    assert_equal length + 1, @owned_object.users.count
  end

  def test_should_remove_an_owner
    @owned_object.users << users(:non_sign_owner)
    length = @owned_object.users.length
    
    assert_difference 'ActionMailer::Base.deliveries.size' do
      delete :remove_owner, id: @owned_object, format: :js, user_id: users(:non_sign_owner).id
    end

    assert_equal length - 1, @owned_object.users.count
  end
end