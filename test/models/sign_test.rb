require 'test_helper'

class SignTest < ActiveSupport::TestCase

  setup do
    @sign = @object = signs(:default)
    @slide  = slides(:standard) # The fixures already relate @sign and @slide
    @user   = users(:non_sign_owner)
    @sign.sign_slides.update_all(approved: true)
  end

  test 'fixtures are safe' do
    assert @sign.valid?
  end

  test 'validates name presence' do
    @sign.name = nil
    assert_not @sign.valid?
  end

  test "playable_slides removes hidden slides" do
    @slide.update(show: false)
    assert_equal(0, @sign.playable_slides.length)
  end

  test "playable_slides with play_on and stop_on" do
    @slide.update(show: true, play_on: Time.zone.parse('1/1/2015 1:00pm'), stop_on: Time.zone.parse('1/5/2015 1:00pm'))
    travel_to Time.zone.parse('1/1/2015 12:59pm') do
      assert_equal(0, @sign.playable_slides.count)
    end
    travel_to Time.zone.parse('1/1/2015 1:01pm') do
      assert_equal(1, @sign.playable_slides.count)
    end
    travel_to Time.zone.parse('1/5/2015 1:01pm') do
      assert_equal(0, @sign.playable_slides.count)
    end
  end

  test "playable_slides with only play_on" do
    @slide.update(show: true, play_on: Time.zone.parse('1/1/2015 1:00pm'), stop_on: nil)
    travel_to Time.zone.parse('1/1/2015 12:59pm') do
      assert_equal(0, @sign.playable_slides.count)
    end
    travel_to Time.zone.parse('1/1/2020 1:01pm') do
      assert_equal(1, @sign.playable_slides.count)
    end
  end

  test "playable_slides with only stop_on" do
    @slide.update(show: true, stop_on: Time.zone.parse('1/5/2015 1:00pm'))
    travel_to Time.zone.parse('1/1/2015 12:59pm') do
      assert_equal(1, @sign.playable_slides.count)
    end
    travel_to Time.zone.parse('1/5/2015 1:01pm') do
      assert_equal(0, @sign.playable_slides.count)
    end
  end

  test 'playable_slides without any play_on/stop_ons' do
    @slide.update(show: true, play_on: nil, stop_on: nil)
    assert_equal(1, @sign.playable_slides.count)
  end

  test 'unexpired_slides filters expired slides' do
    @sign.sign_slides << sign_slides(:expired)
    assert_equal(1, @sign.unexpired_slides.count)
  end

  test 'active? returns true' do
    @sign.touch_last_ping
    assert @sign.active?
  end

  test 'active? returns false' do
    travel_to (Time.zone.now - 8.seconds) do
      @sign.touch_last_ping
    end
    assert_not @sign.active?
  end

  test 'active? with nil returns false' do
    @sign.last_ping = nil
    assert_not @sign.active?
  end

  test 'any_emergency? when all nil' do
    assert_not Sign.new.any_emergency?
  end

  test 'any_emergency? when empty string' do
    assert_not Sign.new(emergency: '').any_emergency?
  end

  test 'any_emergency? when panther alert' do
    assert Sign.new(panther_alert: 'hi').any_emergency?
  end

  test 'any_emergency? when panther alert detail' do
    assert Sign.new(panther_alert_detail: 'hi').any_emergency?
  end

  test 'any_emergency? when panther alert detail empty string' do
    assert_not Sign.new(panther_alert_detail: '  ').any_emergency?
  end
end