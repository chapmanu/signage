require 'test_helper'

class SlideDraftTest < Capybara::Rails::TestCase
  include Rack::Test::Methods

  setup do
    sign_in users(:james)
    @slide = slides(:one)
  end

  teardown do
    # sign_out
  end

  test "drafts have equivalent negative ids" do
    visit draft_slide_path(@slide)
    assert_equal -1 * @slide.id, Slide.unscoped.order(created_at: :desc).first.id
  end

  test "drafts dont have associations to signs" do
    @slide.signs << signs(:one)
    assert_equal 1, @slide.signs.length

    visit draft_slide_path(@slide)
    assert_equal 0, Slide.unscoped.find(@slide.draft_id).signs.length
  end

  scenario "updating scheduled items does not result in duplicates", :js do  
    skip('Need to add a javascript driver to the project')

    visit edit_slide_path

    patch draft_slide_path(@slide), { slide: { scheduled_items_attributes: [ { date: 'Right Now'} ] } }
    patch draft_slide_path(@slide), { slide: { scheduled_items_attributes: [ { date: 'Right Now'} ] } }
  
    assert_equal 200, page.status_code

    draft = @slide.find_or_create_draft
    assert_equal 1, draft.scheduled_items.length
  end

  test "can preview a draft" do
    draft = @slide.find_or_create_draft
    visit preview_slide_path(draft)
    assert_equal 200, page.status_code
  end

  test "cannot show a draft" do
    draft = @slide.find_or_create_draft
    visit slide_path(draft)
    assert_equal 404, page.status_code
  end

  test "cannot edit a draft" do
    draft = @slide.find_or_create_draft
    visit edit_slide_path(draft)
    assert_equal 404, page.status_code
  end
end