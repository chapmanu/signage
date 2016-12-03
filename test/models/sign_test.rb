require 'test_helper'

class SignTest < ActiveSupport::TestCase

  setup do
    @sign = @object = signs(:one)
    @slide  = slides(:one) # The fixures already relate @sign and @slide
    @user   = users(:one)
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
    turn_vcr_off
    mock_campus_alert_feed_with_no_alerts

    assert_not Sign.new.any_emergency?

    turn_vcr_on
  end

  test 'any_emergency? when empty string' do
    turn_vcr_off
    mock_campus_alert_feed_with_no_alerts

    assert_not Sign.new(emergency: '').any_emergency?

    turn_vcr_on
  end

  test 'expects any_emergency? to be true when campus alert' do
    turn_vcr_off
    mock_campus_alert_feed_with_alert

    assert Sign.new.any_emergency?

    turn_vcr_on
  end

  test 'expects campus_alert? to be true' do
    turn_vcr_off
    mock_campus_alert_feed_with_alert

    assert Sign.new.campus_alert?

    turn_vcr_on
  end

  test 'expects campus_alert? to be false' do
    turn_vcr_off
    mock_campus_alert_feed_with_no_alerts

    assert_not Sign.new.campus_alert?

    turn_vcr_on
  end

  test 'expects default campus_alert_feed value to be config value' do
    sign = Sign.new
    assert_equal sign.campus_alert_feed, Rails.configuration.x.campus_alert.feed
  end

  test 'expects to set campus_alert_feed value in staging environment' do
    # Mock staging env: http://stackoverflow.com/a/9119087/6763239
    Rails.stub(:env, ActiveSupport::StringInquirer.new("staging")) do
      sign = Sign.new
      test_feed_url = 'http://signage-staging.chapman.edu/mock/campus_alerts_feed/emergency'
      sign.campus_alert_feed = test_feed_url
      assert_equal sign.campus_alert_feed, test_feed_url
    end
  end

  test 'expects to set campus_alert_feed to be config value when set to nil' do
    sign = Sign.new
    sign.campus_alert_feed = nil
    assert_equal sign.campus_alert_feed, Rails.configuration.x.campus_alert.feed
  end
end