require 'test_helper'

class SearchFiltersTest < ActionDispatch::IntegrationTest

  test "saves last filter selection in cookies" do
    sign_in users(:james)
    visit slides_path
    within '.search-filters-container' do
      ap all('.active').map(&:text)
    end
  end
end