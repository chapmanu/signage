require 'test_helper'

class SlideTest < ActiveSupport::TestCase
  include SchedulableInterfaceTest

  setup do
    @slide = @object = slides(:standard)
    @user = users(:one)
  end

  test 'fixture is valid' do
    assert slides(:standard).valid?
  end

  test 'validates menu_name presence' do
    slide = slides(:standard)
    slide.menu_name = nil
    assert_not slide.valid?
  end

  test 'validates template presence' do
    slide = slides(:standard)
    slide.template = nil
    assert_not slide.valid?
  end

  test "touches signs when save" do
    slide  = slides(:standard)
    sign = signs(:default)
    slide.signs << sign unless slide.signs.include?(sign)
    sign_updated = sign.updated_at
    slide.save
    assert_not_equal(sign_updated, sign.reload.updated_at)
  end

  test 'duration must be larger than 4 seconds' do
    slide = slides(:standard)
    slide.duration = 4
    assert_not slide.valid?
  end

  test "expects default duration to be 10 seconds" do
    # As specified by product owners.
    slide = Slide.new
    assert_equal slide.duration, 10
  end
end
