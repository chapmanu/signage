require 'test_helper'

class FetchDeviceDataJobTest < ActiveJob::TestCase

  test 'returns the sign' do
    assert perform_job_with_scheduled_items.is_a?(Sign), "#perform did not return a sign"
  end

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

  test "it saves the building_name" do
    perform_job_with_people
    s = Slide.where(menu_name: 'OH Faculty').first
    assert_equal('Oliphant Hall', s.building_name)
  end

  test "it saves play_on and stop_on" do
    perform_job_with_people
    s = Slide.where(name: 'digital-signage/slides/copa/11nov15-saxophone-ensemble').first
    assert_equal(DateTime.new(2015, 11, 16), s.play_on)
    assert_equal(DateTime.new(2015, 11, 19, 23, 59), s.stop_on)
  end

  test "its saves scheduled items play_on and stop_on" do
    perform_job_with_scheduled_items
    s = ScheduledItem.where(name: 'September Information Session').first
    assert_equal(DateTime.new(2015, 8, 20), s.play_on)
    assert_equal(DateTime.new(2015, 8, 20, 23, 59, 59), s.stop_on)
  end

  test "it saves play_on as nil if it is blank" do
    perform_job_with_people
    slide = Slide.where(menu_name: '16-17 Audition Dates').first
    assert_nil(nil, slide.play_on)
    assert_nil(nil, slide.stop_on)
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
