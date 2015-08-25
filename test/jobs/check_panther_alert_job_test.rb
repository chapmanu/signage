require 'test_helper'

class CheckPantherAlertJobTest < ActiveJob::TestCase
  test "panther alert is off" do
    VCR.use_cassette(:panther_alert_off) do
      CheckPantherAlertJob.perform_now
    end
    assert_equal [nil], Device.pluck(:panther_alert).uniq
    assert_equal [nil], Device.pluck(:panther_alert_detail).uniq
  end

  test "panther alert is on" do
    VCR.use_cassette(:panther_alert_on, update_content_length_header: false) do
      CheckPantherAlertJob.perform_now
    end
    assert_equal ['Active Shooter 1'],                                Device.pluck(:panther_alert).uniq
    assert_equal ['This is a test. This is only a test. Thank you.'], Device.pluck(:panther_alert_detail).uniq
  end
end
