require 'test_helper'

class SendSlideToSignTest < Capybara::Rails::TestCase
  setup do
    signs(:one).update(name: 'Ross Sign')
    signs(:one).slides.clear
    users(:ross).signs << signs(:one)
  end

  scenario "sending and approving" do
    sign_in users(:james)
    create_new_standard_slide(name: 'James Slide')
    assert_difference 'sent_emails.length' do
      send_to_sign 'Ross Sign (requires approval)'
    end
    assert_not slide_is_on_sign?('James Slide', signs(:one))
    sign_out
    sign_in users(:ross)
    assert page.has_content?(/James Slide needs to be approved to .* Ross Sign/)
    assert page.has_content?(/October 5, 2016/)
    assert page.has_no_content?(/Ending on/)
    assert_difference 'sent_emails.length' do
      click_link 'Approve'
    end
    assert slide_is_on_sign?('James Slide', signs(:one))
  end

  scenario "sending and rejecting" do
    sign_in users(:james)
    create_new_standard_slide(name: 'James Slide')
    send_to_sign 'Ross Sign (requires approval)'
    sign_out
    sign_in users(:ross)
    assert_difference 'sent_emails.length' do
      click_link 'Reject'
    end
    assert_not slide_is_on_sign?('James Slide', signs(:one))
  end

  scenario "sending to sign you own" do
    sign_in users(:ross)
    create_new_standard_slide(name: 'Ross Slide')
    assert_no_difference 'sent_emails.length' do
      send_to_sign 'Ross Sign'
    end
    visit root_path
    assert page.has_no_content?(/(Reject|Approve)/)
    assert slide_is_on_sign?('Ross Slide', signs(:one))
  end

  private

    def slide_is_on_sign?(slide_name, sign)
      visit play_sign_path(sign)
      page.has_content?(slide_name)
    end

    def send_to_sign(name)
      select name, from: 'slide_sign_ids'
      click_button 'Update Slide'
    end

    def create_new_standard_slide(args)
      visit slides_path
      click_link "New"
      fill_in 'slide_menu_name', with: args[:name]
      select 'Standard', from: 'slide_template'
      click_button 'Next'
    end

    def sent_emails
      ActionMailer::Base.deliveries
    end
end