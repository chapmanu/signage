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

    # Rearrange
    turn_vcr_on
  end

  test 'expects no emergency alert' do
    turn_vcr_off

    # Act
    mock_no_public_safety_emergency_alert

    # Assert
    assert_not PublicSafetyService.emergency_alert?

    turn_vcr_on
  end
end
