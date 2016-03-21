require 'test_helper'

class CreateSlideFromSignTest < Capybara::Rails::TestCase
  let(:sign) { signs(:one) }
  let(:user) { users(:james)}
  
  setup do
    sign.owners << user
    sign_in user  
  end

  test "click create slide from sign page" do
    visit sign_path(sign)
    click_link '+ New Slide'
    fill_in 'Slide name', with: 'pickles'
    select  'Standard',   from: 'Select slide template'
    click_button 'Next'
    assert Slide.last.signs.include?(sign), "New slide is not connected to parent sign"
  end
end