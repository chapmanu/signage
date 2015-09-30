require 'test_helper'

class SlideUserTest < ActiveSupport::TestCase
  include UniqueHasManyThroughJoinTableTest

  setup do
    @left_object  = slides(:one)
    @right_object = users(:one)
  end
end
