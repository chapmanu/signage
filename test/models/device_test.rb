require 'test_helper'

class DeviceTest < ActiveSupport::TestCase
  setup do
    @device = devices(:one)
    @slide  = slides(:one)
  end

  test "#active_slides removes hidden slides" do
    @slide.update(show: false)
    @device.slides << @slide
    assert_equal(0, @device.active_slides.length)
  end

  test "#active_slides with play_on and stop_on" do
    @slide.update(show: true, play_on: Time.zone.parse('1/1/2015 1:00pm'), stop_on: Time.zone.parse('1/5/2015 1:00pm'))
    travel_to Time.zone.parse('1/1/2015 12:59pm')
    @device.slides << @slide
    assert_equal(0, @device.active_slides.count)
    travel_to Time.zone.parse('1/1/2015 1:01pm')
    assert_equal(1, @device.active_slides.count)
    travel_to Time.zone.parse('1/5/2015 1:01pm')
    assert_equal(0, @device.active_slides.count)
  end

  test "#active_slides with only play_on" do
    @slide.update(show: true, play_on: Time.zone.parse('1/1/2015 1:00pm'), stop_on: nil)
    travel_to Time.zone.parse('1/1/2015 12:59pm')
    @device.slides << @slide
    assert_equal(0, @device.active_slides.count)
    travel_to Time.zone.parse('1/1/2020 1:01pm')
    assert_equal(1, @device.active_slides.count)
  end

  test "#active_slides with only stop_on" do
    @slide.update(show: true, stop_on: Time.zone.parse('1/5/2015 1:00pm'))
    travel_to Time.zone.parse('1/1/2015 12:59pm')
    @device.slides << @slide
    assert_equal(1, @device.active_slides.count)
    travel_to Time.zone.parse('1/5/2015 1:01pm')
    assert_equal(0, @device.active_slides.count)
  end

  test '#active_slides without any play_on/stop_ons' do
    @slide.update(show: true, play_on: nil, stop_on: nil)
    @device.slides << @slide
    assert_equal(1, @device.active_slides.count)
  end
end