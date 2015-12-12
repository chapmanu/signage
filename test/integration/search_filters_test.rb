require 'test_helper'

class SearchFiltersTest < ActionDispatch::IntegrationTest

  test "saves last filter selection in cookies" do
    sign_in users(:james)

  end
end