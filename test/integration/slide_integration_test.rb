require 'test_helper'

class SlideIntegrationTest < Capybara::Rails::TestCase
  let(:user) { users(:james) }
  let(:slide) { slides(:standard)}
  let(:vert_social_slide) { slides(:social_feed_vertical) }
  let(:horiz_social_slide) { slides(:social_feed_horizontal) }
  let(:standard_slide) { slides(:standard) }
  let(:scheduled_item) { scheduled_items(:standard) }

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

  # This admission test is to confirm that the admission and audience labels properly match
  # their respective options. This is due to an issue where the data in the database had
  # accidentally been swapped, shown here: https://github.com/chapmanu/signage/issues/188
  test "schedule slide's admission and audience have the correct options" do
    slide.update(template: 'schedule')
    slide.scheduled_items << scheduled_item

    visit edit_slide_path(slide)
    assert page.has_select?('Admission', :with_options => ['Free']), "Admission does not include 'Free'"
    assert page.has_select?('Audience', :with_options => ['Students']), "Admission does not include 'Students'"
  end

  # TODO: We are already aware of the mix of minitest and rspec syntax and that the below
  # set of tests are inconsistent with all other tests. At the moment it is not affecting
  # test performances negatively. If it becomes a problem we'll change the below tests to
  # match all other tests.
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