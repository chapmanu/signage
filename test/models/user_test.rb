require 'test_helper'

class UserTest < ActiveSupport::TestCase
  include ActiveDirectoryLookupsTest
  include UniqueHasManyThroughTest

  setup do
    @user = @object = users(:one)
  end
end
