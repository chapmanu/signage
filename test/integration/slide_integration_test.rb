require 'test_helper'

class SlideIntegrationTest < Capybara::Rails::TestCase
  let(:user) { users(:james) }
  let(:slide) { slides(:standard)}
  let(:vert_social_slide) { slides(:social_feed_vertical) }
  let(:horiz_social_slide) { slides(:social_feed_horizontal) }
  let(:standard_slide) { slides(:standard) }
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

  describe "Selecting slide orientation" do
    before { sign_in(users(:super_admin)) }

    it "Social Feed slide can select vertical orientation", js: true do
      visit edit_slide_path(vert_social_slide)
      assert page.has_content?("Select slide orientation")
    end

    it "Standard slide can not select vertical orientation", js: true do
      visit edit_slide_path(standard_slide)
      assert page.has_no_content?("Select slide orientation")
    end
  end

  describe "Slide orientation when previewing social feed slide" do
    before{ sign_in(users(:super_admin)) }

    it "uses vertical style", js: true do
      visit preview_slide_path(vert_social_slide)
      assert page.has_css?("div.social-feed-container.vertical")
    end

    it "uses horizontal style", js: true do
      visit preview_slide_path(horiz_social_slide)
      assert page.has_css?("div.social-feed-container.horizontal")
    end
  end
end