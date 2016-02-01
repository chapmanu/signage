require 'test_helper'

class ImportCascadeSignTest < Capybara::Rails::TestCase
  
  setup do
    sign_in users(:james)
  end  

  test "imports from cascade" do
    VCR.use_cassette(:manual_cascade_import) do
      assert_difference 'Sign.count', 1, 'Signs count did not change' do
        visit cascade_form_path
        fill_in "cascade_url", with: "http://www2.chapman.edu/digital-signage/devices/hashinger-science-center-1st-floor"
        click_button "Import"
        assert_equal sign_path(Sign.last), page.current_path
      end
    end
  end

  test "renders error if url is wrong" do
    visit cascade_form_path
    fill_in 'cascade_url', with: 'blah http://www2.chapman.edu/digital-signage/devices/no-device-at-this-url'
    click_button "Import"
    assert page.has_content?("invalid"), "Did not render error message."
  end

  test "renders error if import goes wrong" do
    VCR.use_cassette(:failed_manual_cascade_import) do
      visit cascade_form_path
      fill_in 'cascade_url', with: 'http://www2.chapman.edu/digital-signage/devices/no-device-at-this-url'
      click_button "Import"
      assert page.has_content?("Could not find"), "Did not render error message."
    end
  end
end