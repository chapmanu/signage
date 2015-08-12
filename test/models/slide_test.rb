require 'test_helper'

class SlideTest < ActiveSupport::TestCase
  test "touches devices when save" do
    slide  = slides(:one)
    device = devices(:one)
    slide.devices << device
    device_updated = device.updated_at
    slide.save
    assert_not_equal(device_updated, device.reload.updated_at)
  end

  test '#active' do
    travel_to Time.zone.parse('1/1/2015 5:00pm')
    assert Slide.new(play_on: nil, stop_on: nil).active?
    assert Slide.new(play_on: Time.current, stop_on: Time.current).active?
    assert_not Slide.new(play_on: Time.current - 2.minutes, stop_on: Time.current - 1.minute).active?
    assert_not Slide.new(play_on: Time.current + 1.minute, stop_on: nil).active?
    assert_not Slide.new(play_on: nil, stop_on: Time.current - 1.minute).active?
  end
end
