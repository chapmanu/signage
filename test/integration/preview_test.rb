require 'test_helper'

class PreviewTest < Capybara::Rails::TestCase

	setup do
		signs(:default).update(name: 'Ross Sign')
    	signs(:default).slides.clear
		users(:ross).signs << signs(:default)
	end

	scenario "notifications have slide preview for sign owners" do 
		sign_in users(:james)
    	
    	visit new_slide_path
    	fill_in 'slide_menu_name', with: 'Non Sign Owner Slide'
    	select 'Standard', from: 'slide_template'
    	click_button 'Next'
    	select 'Ross Sign (requires approval)'
    	click_button 'Update Slide'
    	sign_out
		
		sign_in users(:ross)

		assert page.has_css?('div.slide-preview-wrapper iframe'), "Preview is not present for sign owner"
	end

	scenario "notifications do not have slide preview for non sign owners" do 
		sign_in users(:james)

		assert page.has_no_css?('div.slide-preview-wrapper iframe'), "Preview is present for non sign owner"
	end

end