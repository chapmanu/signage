require 'test_helper'

class UserTest < ActiveSupport::TestCase
  include ActiveDirectoryLookupsTest

  setup do
    @user = @object = users(:one)
  end
end
