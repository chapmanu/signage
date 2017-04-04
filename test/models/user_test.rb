require 'test_helper'

class UserTest < ActiveSupport::TestCase
  include ActiveDirectoryLookupsTest

  setup do
    @user = @object = users(:non_sign_owner)
  end
end
