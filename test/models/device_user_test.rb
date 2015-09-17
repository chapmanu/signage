require 'test_helper'

class DeviceUserTest < ActiveSupport::TestCase
  setup do
    @device = devices(:one)
    @user   = users(:one)
  end

  test "a user can join with a device once" do
    assert_not @device.users.include?(@user)
    @device.users << @user
    assert_raise ActiveRecord::RecordInvalid do
      @device.users << @user
    end
  end
end
