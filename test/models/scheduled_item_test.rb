require 'test_helper'

class ScheduledItemTest < ActiveSupport::TestCase
  include SchedulableInterfaceTest

  setup do
    @scheduled_item = @object = ScheduledItem.new
  end
end
