require 'test_helper'

class SignPermissionTest < Capybara::Rails::TestCase
  let (:user) { users(:ross) }
  
  before do
    sign_in user
    user.signs.clear
  end

  describe "when user is not owner" do
    test "index page edit button is absent" do
      visit signs_path
      assert page.has_no_content?('Edit'), "Edit button is present"
    end

    test "remove owner button is absent" do
      signs(:one).users << users(:two)
      visit sign_path(signs(:one))
      assert page.has_no_css?('a.remove-owner'), "Remove owner link present"
    end

    test "add owner form is absent" do
      visit sign_path(signs(:one))
      assert page.has_no_css?('form#add-owner'), "Add owner form is present"
    end

    test "edit button is absent" do
      visit sign_path(signs(:one))
      within '.actions' do
        assert page.has_no_content?("Edit"), "Edit button is present"
      end
    end

    test "delete button is absent" do
      visit sign_path(signs(:one))
      within '.actions' do
        assert page.has_no_content?("Delete"), "Delete button is present"
      end
    end

    test "slides cannot be reodered" do
      visit sign_path(signs(:one))
      assert page.has_no_css?('#js-sortable-slides'), "Slides are sortable"
    end

    test "remove slide button is absent" do
      visit sign_path(signs(:one))
      assert page.has_no_css?('.destroy-slide-sign'), "Destroy sign slide is present"
    end

    test "add slide button is absent" do
      visit sign_path(signs(:one))
      assert page.has_no_content?("+ New Slide"), "New slide button is present"
    end

    test "edit slide button is absent" do
      visit sign_path(signs(:one))
      within '.sign-slides-listing' do
        assert page.has_no_content?("Edit"), "Edit slide button is present"
      end
    end

    test "edit page is not accessible" do
      visit edit_sign_path(signs(:one))
      assert_equal 403, page.status_code
    end
  end

end