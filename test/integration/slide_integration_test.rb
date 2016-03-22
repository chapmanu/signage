require 'test_helper'

class SlideIntegrationTest < Capybara::Rails::TestCase
  let(:user) { users(:james) }
  let(:slide) { slides(:one)}
  let(:scheduled_item) { scheduled_items(:one) }

  setup do
    slide.owners << user
    sign_in user
  end

  test "schedule slide complete scheduled item" do
    scheduled_item.update({admission: 'Free', audience: 'Students'})
    slide.update(template: 'schedule')
    slide.scheduled_items << scheduled_item
    
    visit preview_slide_path(slide)
    assert page.has_css?('img#ui-event-admission-icon'), "Admission icon is not present"
    assert page.has_css?('img#ui-event-audience-icon'), "Audience icon is not present"
  end

  test "scheduled item w/o admission & audience" do
    scheduled_item.update({admission: '', audience: ''})
    slide.update(template: 'schedule')
    slide.scheduled_items << scheduled_item

    visit preview_slide_path(slide)
    assert page.has_no_css?('img#ui-event-admission-icon'), "Admission icon is present"
    assert page.has_no_css?('img#ui-event-audience-icon'), "Audience icon is present"
  end
end