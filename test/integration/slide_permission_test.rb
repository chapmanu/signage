require 'test_helper'

class SlidePermissionTest < Capybara::Rails::TestCase
  
  let(:user) { users(:ross) }

  before do
    user.slides.clear
    sign_in user
  end
  
  describe "when user is not owner" do
    test "edit button is not present on index" do
      visit slides_path
      assert page.has_no_content?('Edit'), "Edit button is present"
    end

    test "hide edit button on show" do
      visit slide_path(slides(:standard))
      assert page.has_no_content?('Edit'), "Edit button is present"
    end

    test "private signs are not listed under Send to Slide" do
      # Act/Arrange
      visit slide_path(slides(:standard))
      private_sign = signs(:private)
      public_sign = signs(:build_team_area)
      assert_equal private_sign.owners.include?(user), false

      # Assert
      within '.edit_slide' do
        assert page.has_no_content?(private_sign.name)
        assert page.has_content?(public_sign.name)
      end
    end

    test "remove owner button is absent" do
      slides(:standard).users << users(:non_sign_owner)
      visit slide_path(slides(:standard))
      assert page.has_no_css?('a.remove-owner'), "Remove owner link present"
    end

    test "add owner form is absent" do
      visit slide_path(slides(:standard))
      assert page.has_no_css?('form#add-owner'), "Add owner form is present"
    end

    test "slide edit page is not accessible" do
      visit edit_slide_path(slides(:standard))
      assert_equal 403, page.status_code
    end
  end
end