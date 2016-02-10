require 'test_helper'

class SlideIntegrationTest < Capybara::Rails::TestCase
  setup do
    @slide = slides(:one)
    @scheduled_item = scheduled_items(:one)
    sign_in users(:james)
  end

  test "schedule slide complete scheduled item" do
    @scheduled_item.update({admission: 'Free', audience: 'Students'})
    @slide.update(template: 'schedule')
    @slide.scheduled_items << @scheduled_item
    
    visit preview_slide_path(@slide)
    assert page.has_css?('img#ui-event-admission-icon')
    assert page.has_css?('img#ui-event-audience-icon')
  end

  test "scheduled item w/o admission & audience" do
    @scheduled_item.update({admission: '', audience: ''})
    @slide.update(template: 'schedule')
    @slide.scheduled_items << @scheduled_item

    visit preview_slide_path(@slide)
    assert page.has_no_css?('img#ui-event-admission-icon')
    assert page.has_no_css?('img#ui-event-audience-icon')
  end
end