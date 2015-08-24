require 'test_helper'

class FacultyTest < ActiveSupport::TestCase
  test 'default_scope orders by last_name' do
    assert_equal ["Dr. James Kerr", "Rev. Clive Staples"], Faculty.pluck(:full_name)
  end

  test ".in_building" do
    assert_equal 2, Faculty.in_building('Dodge College').count
  end

  test '.all_building_names' do
    assert_equal ['Crean Hall', 'Dodge College'], Faculty.all_building_names
  end
end
