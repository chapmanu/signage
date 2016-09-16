require 'test_helper'

class FetchFacultyDataJobTest < ActiveJob::TestCase
  @@already_performed = false

  setup do
    perform_job
  end

  test 'it saves data' do
    assert_equal @@before_count + 1115, @@after_count
  end

  test 'it saves building info' do
    assert_equal '', @@suzanne.building_name
  end

  test 'it saves office info' do
    assert_equal '', @@suzanne.office_name
  end

  test 'saves thumbnail' do
    assert_equal 'http://www.chapman.edu/our-faculty/files/small-photos/adjunct-faculty/Wright_S.jpg', @@suzanne.thumbnail
  end

  test 'saves email' do
    assert_equal 'yalcin@chapman.edu', @@taylan.email
  end

  test 'saves phone number' do
    assert_equal '714-289-3119', @@taylan.phone
  end

  test 'saves first_name' do
    assert_equal 'Taylan', @@taylan.first_name
  end

  test 'saves last_name' do
    assert_equal 'Yalcin', @@taylan.last_name
  end

  test 'saves full_name' do
    assert_equal 'Dr. Taylan Yalcin', @@taylan.full_name
  end

  test 'saves all building names' do
    assert_equal expected_building_names, @@building_names
  end

  private
    def perform_job
      return if @@already_performed

      @@before_count   = Faculty.count
      VCR.use_cassette("faculty_data") { FetchFacultyDataJob.perform_now }
      @@after_count    = Faculty.count

      @@suzanne        = Faculty.find_by_datatel_id(1564341)
      @@taylan         = Faculty.find_by_datatel_id(1757372)
      @@building_names = Faculty.all_building_names

      @@already_performed = true
    end

    def expected_building_names
      [
        "Argyros Forum",
        "Becket Building",
        "Beckman Hall",
        "Bertea Hall",
        "Crean Hall",
        "DeMille Hall",
        "Digital Media Arts Center",
        "Doti Hall",
        "Entertainment Technology Center",
        "Fish Interfaith Center",
        "Hashinger Science Center",
        "Kennedy Hall",
        "Leatherby Libraries",
        "Marion Knott Studios",
        "Memorial Hall",
        "Moulton Hall",
        "Oliphant Hall",
        "Partridge Dance Center",
        "Reeves Hall",
        "Rinker Health Science Campus",
        "Roosevelt Hall",
        "Smith Hall",
        "Von Neumann Hall",
        "Wilkinson Hall"
      ]
    end
end
