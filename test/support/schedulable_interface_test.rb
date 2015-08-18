# This test should be used on all classes with the Schedulable concern included.
module SchedulableInterfaceTest

  def test_respond_to_play_on
    assert_respond_to(@object, :play_on)
  end

  def test_respond_to_stop_on
    assert_respond_to(@object, :stop_on)
  end

  def test_respond_to_active
    assert_respond_to(@object.class, :active)
  end

  def test_responds_to_active?
    assert_respond_to(@object, :active?)
  end

  def test_responds_to_expired?
    assert_respond_to(@object, :expired?)
  end

  def test_responds_to_upcoming?
    assert_respond_to(@object, :upcoming?)
  end

  def test_active?
    travel_to Time.zone.parse('1/1/2015 5:00pm') do
      @object.attributes = { play_on: nil, stop_on: nil }
      assert @object.active?

      @object.attributes = { play_on: Time.current, stop_on: Time.current }
      assert @object.active?

      @object.attributes = { play_on: Time.current - 2.minutes, stop_on: Time.current - 1.minute }
      assert_not @object.active?

      @object.attributes = { play_on: Time.current + 1.minute, stop_on: nil }
      assert_not @object.active?

      @object.attributes = { play_on: nil, stop_on: Time.current - 1.minute }
      assert_not @object.active?
    end
  end
end