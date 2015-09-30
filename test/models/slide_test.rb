require 'test_helper'

class SlideTest < ActiveSupport::TestCase
  include SchedulableInterfaceTest
  include UniqueHasManyThroughTest

  setup do
    @slide = @object = Slide.new
    @user = users(:one)
  end

  test 'fixture is valid' do
    assert slides(:one).valid?
  end

  test 'validates menu_name presence' do
    slide = slides(:one)
    slide.menu_name = nil
    assert_not slide.valid?
  end

  test 'validates template presence' do
    slide = slides(:one)
    slide.template = nil
    assert_not slide.valid?
  end

  test "touches devices when save" do
    slide  = slides(:one)
    device = devices(:one)
    slide.devices << device unless slide.devices.include?(device)
    device_updated = device.updated_at
    slide.save
    assert_not_equal(device_updated, device.reload.updated_at)
  end

  test 'duration must be larger than 4 seconds' do
    slide = slides(:one)
    slide.duration = 4
    assert_not slide.valid?
  end
end
