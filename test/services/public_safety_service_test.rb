# test/services/public_safety_service_test.rb

require 'test_helper'

class PublicSafetyServiceTest < ActiveSupport::TestCase
  test 'expects emergency alert' do
    # Arrange
    turn_vcr_off

    # Act
    mock_public_safety_emergency_alert

    # Assert
    assert PublicSafetyService.emergency_alert?

    # Unarrange
    turn_vcr_on
  end

  test 'expects no emergency alert' do
    turn_vcr_off
    mock_no_public_safety_emergency_alert
    assert_not PublicSafetyService.emergency_alert?
    turn_vcr_on
  end

  test 'expects no emergency alert when emergency alert feed is inaccessible' do
    # Arrange
    turn_vcr_off
    cases = [404, 500]

    cases.each do | status |
      # Act
      stub_public_safety_feed(status: status)

      # Assert
      assert_not PublicSafetyService.emergency_alert?
    end

    # Unarrange
    turn_vcr_on
  end

  test 'expects to skip alert check when safety feed config is blank' do
    # Arrange
    turn_vcr_off
    cases = ['', nil]

    cases.each do | blank_value |
      # Stub config value to be empty.
      Rails.configuration.x.public_safety.stub(:feed, blank_value) do
        # I'd also like to assert that RestClient::Request.execute is not called, but
        # couldn't find a simple way to do it in MiniTest.

        # Act / Assert
        refute PublicSafetyService.emergency_alert?
      end
    end

    # Unarrange
    turn_vcr_on
  end
end
