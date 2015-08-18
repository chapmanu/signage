require 'test_helper'

class DeviceTest < ActiveSupport::TestCase
  setup do
    @device = devices(:one)
    @slide  = slides(:one)
  end

  test 'fixtures are safe' do
    assert @device.valid?
  end

  test 'validates name presence' do
    @device.name = nil
    assert_not @device.valid?
  end

  test "#active_slides removes hidden slides" do
    @slide.update(show: false)
    @device.slides << @slide
    assert_equal(0, @device.active_slides.length)
  end

  test "#active_slides with play_on and stop_on" do
    @slide.update(show: true, play_on: Time.zone.parse('1/1/2015 1:00pm'), stop_on: Time.zone.parse('1/5/2015 1:00pm'))
    travel_to Time.zone.parse('1/1/2015 12:59pm') do
      @device.slides << @slide
      assert_equal(0, @device.active_slides.count)
    end
    travel_to Time.zone.parse('1/1/2015 1:01pm') do
      assert_equal(1, @device.active_slides.count)
    end
    travel_to Time.zone.parse('1/5/2015 1:01pm') do
      assert_equal(0, @device.active_slides.count)
    end
  end

  test "#active_slides with only play_on" do
    @slide.update(show: true, play_on: Time.zone.parse('1/1/2015 1:00pm'), stop_on: nil)
    travel_to Time.zone.parse('1/1/2015 12:59pm') do
      @device.slides << @slide
      assert_equal(0, @device.active_slides.count)
    end
    travel_to Time.zone.parse('1/1/2020 1:01pm') do
      assert_equal(1, @device.active_slides.count)
    end
  end

  test "#active_slides with only stop_on" do
    @slide.update(show: true, stop_on: Time.zone.parse('1/5/2015 1:00pm'))
    travel_to Time.zone.parse('1/1/2015 12:59pm') do
      @device.slides << @slide
      assert_equal(1, @device.active_slides.count)
    end
    travel_to Time.zone.parse('1/5/2015 1:01pm') do
      assert_equal(0, @device.active_slides.count)
    end
  end

  test '#active_slides without any play_on/stop_ons' do
    @slide.update(show: true, play_on: nil, stop_on: nil)
    @device.slides << @slide
    assert_equal(1, @device.active_slides.count)
  end

  test '#active? returns true' do
    @device.touch_last_ping
    assert @device.active?
  end

  test '#active? returns false' do
    travel_to (Time.zone.now - 8.seconds) do
      @device.touch_last_ping
    end
    assert_not @device.active?
  end

  test '#active? with nil returns false' do
    @device.last_ping = nil
    assert_not @device.active?
  end
end