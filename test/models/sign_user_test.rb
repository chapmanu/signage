require 'test_helper'

class SignUserTest < ActiveSupport::TestCase
  include UniqueHasManyThroughJoinTableTest

  setup do
    @left_object  = signs(:one)
    @right_object = users(:one)
  end
end
