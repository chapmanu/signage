require 'test_helper'

class FetchDeviceDataJobTest < ActiveJob::TestCase

  test "it saves slides" do
    assert_difference 'Slide.count', 6 do
      perform_job_with_people
    end
  end

  test "it saves people" do
    assert_difference 'Person.count', 75 do
      perform_job_with_people
    end
  end

  test "it saves scheduled items" do
    assert_difference 'ScheduledItem.count', 4 do
      perform_job_with_scheduled_items
    end
  end

  test "it saves template, theme, and layout" do
    perform_job_with_people
    s = Slide.last
    assert_equal('standard', s.template)
    assert_equal('dark', s.theme)
    assert_equal('right', s.layout)
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
