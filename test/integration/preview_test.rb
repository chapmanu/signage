require 'test_helper'

class PreviewTest < Capybara::Rails::TestCase
  scenario "notifications have slide preview for sign owners" do 
    # users ross and james are the only users that actually successfully log in
	# Arrange
	@sign = signs(:default)
	@sign.slides << slides(:awaiting_approval)
	@sign.owners << users(:ross)
		
	# Act
	sign_in users(:ross)

	#Assume
	assert page.has_content?("Sign Out"), "User did not successfully log in"

	# Assert
	# Default page after logging in contains notifications/preview that is being tested, don't need to navigate to any other page
	assert page.has_css?('div.slide-preview-wrapper iframe'), "Preview is not present for sign owner"
  end

  scenario "notifications do not have slide preview for non sign owners" do 
	# Act
	sign_in users(:james)

	#Assume
	assert page.has_content?("Sign Out"), "User did not successfully log in"

	# Assert
	assert page.has_no_css?('div.slide-preview-wrapper iframe'), "Preview is present for non sign owner"
  end

end