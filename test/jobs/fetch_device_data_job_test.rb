require 'test_helper'

class FetchDeviceDataJobTest < ActiveJob::TestCase

  test "it saves slides" do
    assert_difference 'Slide.count', 8 do
      perform_job_with_people
    end
  end

  test "it saves scheduled items" do
    assert_difference 'ScheduledItem.count', 2 do
      perform_job_with_scheduled_items
    end
  end

  test "it saves template, theme, and layout" do
    perform_job_with_people
    s = Slide.last
    assert_equal('standard', s.template)
    assert_equal('light', s.theme)
    assert_equal('right', s.layout)
  end

  test "it saves the directory feed field" do
    skip "Don't have the data from Mandy Yet"
  end

  test "it saves play_on and stop_on" do
    perform_job_with_people
    s = Slide.where(name: 'digital-signage/slides/smc/follow-us').first
    assert_equal(DateTime.new(2015, 8, 26), s.play_on)
    assert_equal(DateTime.new(2015, 9, 11, 23, 59), s.stop_on)
  end

  test "its saves scheduled items play_on and stop_on" do
    perform_job_with_scheduled_items
    s = ScheduledItem.where(name: 'September Information Session').first
    assert_equal(DateTime.new(2015, 8, 20), s.play_on)
    assert_equal(DateTime.new(2015, 8, 20, 23, 59, 59), s.stop_on)
  end

  test "it saves play_on as nil if it is blank" do
    perform_job_with_people
    s = Slide.where(name: 'digital-signage/slides/copa/faculty-directory-bertea').first
    assert_equal(nil, s.play_on)
    assert_equal(nil, s.stop_on)
  end

  private
    def perform_job_with_people
      VCR.use_cassette("bertea_hall_entrance") do
        FetchDeviceDataJob.perform_now(url: 'http://www2.chapman.edu/digital-signage/devices/bertea-hall-entrance/slideshow.json')
      end
    end

    def perform_job_with_scheduled_items
      VCR.use_cassette("reeves_hall_lobby") do
        FetchDeviceDataJob.perform_now(url: 'http://www2.chapman.edu/digital-signage/devices/reeves-hall-lobby/slideshow.json')
      end
    end
end
