require 'test_helper'

class SignSlideTest < ActiveSupport::TestCase
  include UniqueHasManyThroughJoinTableTest

  setup do
    @left_object  = signs(:one)
    @right_object = slides(:one)
  end
end
