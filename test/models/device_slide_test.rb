require 'test_helper'

class DeviceSlideTest < ActiveSupport::TestCase
  include UniqueHasManyThroughJoinTableTest

  setup do
    @left_object  = devices(:one)
    @right_object = slides(:one)
  end
end
