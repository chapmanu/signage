require 'test_helper'

class ImportCascadeSignTest < Capybara::Rails::TestCase
  
  setup do
    sign_in users(:james)
    visit cascade_form_path
    @valid_url   = "http://www2.chapman.edu/digital-signage/devices/hashinger-science-center-1st-floor"
    @invalid_url = "blah http://www2.chapman.edu/digital-signage/devices/no-device-at-this-url"
    @missing_url = "http://www2.chapman.edu/digital-signage/devices/no-device-at-this-url"
  end  

  test "imports from cascade" do
    VCR.use_cassette(:manual_cascade_import) do
      assert_difference 'Sign.count', 1, 'Signs count did not change' do
        import @valid_url
        assert_equal sign_path(Sign.last), page.current_path
      end
    end
  end

  test "renders error if url is wrong" do
    import @invalid_url
    assert page.has_content?("invalid"), "Did not render error message."
  end

  test "renders error if import goes wrong" do
    VCR.use_cassette(:failed_manual_cascade_import) do
      import @missing_url
      assert page.has_content?("Could not find"), "Did not render error message."
    end
  end

  test "current_user is sign owner" do
    VCR.use_cassette(:manual_cascade_import) do
      import @valid_url
      assert Sign.last.owners.include?(users(:james)), "current_user is not slide owner"
    end
  end

  test "current_user is owner of all slides" do
    VCR.use_cassette(:manual_cascade_import) do
      import @valid_url
      assert Sign.last.slides.all?{|slide| slide.owners.include?(users(:james))}, "current_user is not owner of all slides"
    end
  end

  test "slides are approved to go on that sign" do
    VCR.use_cassette(:manual_cascade_import) do
      import @valid_url
      assert Sign.last.sign_slides.all?(&:approved), "All slides are not approved"
    end
  end

  private
    def import(url)
      fill_in 'cascade_url', with: url
      click_button "Import"
    end
end