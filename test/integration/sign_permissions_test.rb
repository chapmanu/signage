require 'test_helper'

class SignPermissionTest < Capybara::Rails::TestCase
  let (:user) { users(:ross) }

  before do
    sign_in user
    user.signs.clear
  end

  describe "when user is not owner" do
    test "index page edit button is absent" do
      visit signs_path(filter: 'all')
      assert page.has_no_content?('Edit'), "Edit button is present"
    end

    test "private sign not present on index page" do
      visit signs_path(filter: 'all')
      assert page.has_no_content?('sign_two'), "Private sign is present"
    end

    test "user cannot see private sign listed on owned slide" do
      signs(:dodge).slides << slides(:standard)
      slides(:standard).users << users(:non_sign_owner)
      visit slide_path(slides(:standard))
      assert page.has_no_css?('div.sign-private'), "Private sign is present on slide"
    end

    test "remove owner button is absent" do
      signs(:default).users << users(:non_sign_owner)
      visit sign_path(signs(:default))
      assert page.has_no_css?('a.remove-owner'), "Remove owner link present"
    end

    test "add owner form is absent" do
      visit sign_path(signs(:default))
      assert page.has_no_css?('form#add-owner'), "Add owner form is present"
    end

    test "edit button is absent" do
      visit sign_path(signs(:default))
      within '.actions' do
        assert page.has_no_content?("Edit"), "Edit button is present"
      end
    end

    test "delete button is absent" do
      visit sign_path(signs(:default))
      within '.actions' do
        assert page.has_no_content?("Delete"), "Delete button is present"
      end
    end

    test "slides cannot be reodered" do
      visit sign_path(signs(:default))
      assert page.has_no_css?('#js-sortable-slides'), "Slides are sortable"
    end

    test "remove slide button is absent" do
      visit sign_path(signs(:default))
      assert page.has_no_css?('.destroy-slide-sign'), "Destroy sign slide is present"
    end

    test "add slide button is absent" do
      visit sign_path(signs(:default))
      assert page.has_no_content?("+ New Slide"), "New slide button is present"
    end

    test "edit slide button is absent" do
      visit sign_path(signs(:default))
      within '.sign-slides-listing' do
        assert page.has_no_content?("Edit"), "Edit slide button is present"
      end
    end

    test "edit page is not accessible" do
      visit edit_sign_path(signs(:default))
      assert_equal 403, page.status_code
    end

    test "show page for private sign is not accessible" do
      visit sign_path(signs(:private))
      assert_equal 403, page.status_code
    end

    test "expects play page for private sign to be accessible" do
      visit play_sign_path(signs(:private))
      assert_equal 200, page.status_code
    end
  end

  describe "when user is owner" do
    test "private sign present on index page" do
      user.signs << signs(:dodge)
      visit signs_path(filter: 'all')
      assert page.has_content?('sign_two'), "Private sign is not present"
    end

    test "private sign is marked with red orb on index page" do
      user.signs << signs(:dodge)
      visit signs_path(filter: 'all')
      assert page.has_css?('div.sign-private'), "Private sign is not marked with red orb"
    end

    test "sign visibility select is absent" do
      user.signs << signs(:dodge)
      visit edit_sign_path(signs(:dodge))
      assert page.has_no_content?('Visibility'), "Owner can edit sign visibility"
    end
  end
end