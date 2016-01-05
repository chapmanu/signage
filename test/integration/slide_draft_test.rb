require 'test_helper'

class SlideDraftTest < ActionDispatch::IntegrationTest
  
  setup do
    sign_in users(:james)
    @slide = slides(:one)
  end

  teardown do
    sign_out
  end

  test "drafts have equivalent negative ids" do
    get draft_slide_path(@slide)
    assert_equal -1 * @slide.id, Slide.unscoped.order(created_at: :desc).first.id
  end

  test "drafts dont have associations to signs" do
    @slide.signs << signs(:one)
    assert_equal 1, @slide.signs.length

    get draft_slide_path(@slide)
    assert_equal 0, Slide.unscoped.find(@slide.draft_id).signs.length
  end

  test "updating scheduled items does not result in duplicates" do
    patch draft_slide_path(@slide), { slide: { scheduled_items_attributes: [ { date: 'Right Now'} ] } }
    patch draft_slide_path(@slide), { slide: { scheduled_items_attributes: [ { date: 'Right Now'} ] } }
    
    assert_response :success
    draft = @slide.find_or_create_draft
    assert_equal 1, draft.scheduled_items.length
  end

  test "can preview a draft" do
    draft = @slide.find_or_create_draft
    get preview_slide_path(draft)
    assert_response :success
  end

  test "cannot show a draft" do
    draft = @slide.find_or_create_draft
    get slide_path(draft)
    assert_response :not_found
  end

  test "cannot edit a draft" do
    draft = @slide.find_or_create_draft
    get edit_slide_path(draft)
    assert_response :not_found
  end
end