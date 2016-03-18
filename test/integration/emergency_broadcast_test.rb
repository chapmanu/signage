require 'test_helper'

class EmergencyBroadcastTest < Capybara::Rails::TestCase

  setup do
    sign_in users(:james)
  end

  test "sending emergency messages" do
    visit admin_emergency_path
    fill_in "emergency",        with: "Get to the chopper!"
    fill_in "emergency_detail", with: "Everybody down!"
    check signs(:one).name
    click_button "Broadcast!"
    visit play_sign_path(signs(:one))

    assert page.has_content?("Get to the chopper!"), "Emergency did not appear on slide"
    assert page.has_content?("Everybody down!"),     "Emergency detail did not appear on slide"
  end

  test "clear all emergencies" do
    Sign.update_all emergency_detail: 'Clear Me'

    visit admin_emergency_path
    click_link "Clear All Emergency Messages"
    
    assert_empty all_emergencies, "Did not clear all emergencies"
  end

  test "clear single emergency" do
    clear_emergencies
    signs(:one).update(emergency: 'Clear just me')

    visit admin_emergency_path
    click_link "Clear"
    visit play_sign_path(signs(:one))

    assert page.has_no_content?("Clear just me")
  end

  private

    def clear_emergencies
      Sign.update_all(emergency: nil, emergency_detail: nil)  
    end

    def all_emergencies
      Sign.pluck(:emergency, :emergency_detail).flatten.compact
    end
end