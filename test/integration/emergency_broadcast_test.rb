require 'test_helper'

class EmergencyBroadcastTest < Capybara::Rails::TestCase

  setup do
    # FIXME: This requires a VCR cassette that broken when I changed the super_admin's name in
    # the fixture. web_mock should be used to block and mock all web requests.
    sign_in users(:super_admin)
  end

  test "sending emergency messages" do
    visit emergencies_path
    fill_in "emergency",        with: "Get to the chopper!"
    fill_in "emergency_detail", with: "Everybody down!"
    check signs(:default).name
    click_button "Broadcast!"
    visit play_sign_path(signs(:default))

    assert page.has_content?("Get to the chopper!"), "Emergency did not appear on slide"
    assert page.has_content?("Everybody down!"),     "Emergency detail did not appear on slide"
  end

  test "clear all emergencies" do
    Sign.update_all emergency_detail: 'Clear Me'

    visit emergencies_path
    click_link "Clear All Emergency Messages"

    assert_empty all_emergencies, "Did not clear all emergencies"
  end

  test "clear single emergency" do
    clear_emergencies
    signs(:default).update(emergency: 'Clear just me')

    visit emergencies_path
    click_link "Clear"
    visit play_sign_path(signs(:default))

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