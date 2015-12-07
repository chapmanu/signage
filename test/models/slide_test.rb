require 'test_helper'

class SlideTest < ActiveSupport::TestCase
  include SchedulableInterfaceTest

  setup do
    @slide = @object = slides(:one)
    @user = users(:one)
  end

  test 'fixture is valid' do
    assert slides(:one).valid?
  end

  test 'validates menu_name presence' do
    slide = slides(:one)
    slide.menu_name = nil
    assert_not slide.valid?
  end

  test 'validates template presence' do
    slide = slides(:one)
    slide.template = nil
    assert_not slide.valid?
  end

  test "touches signs when save" do
    slide  = slides(:one)
    sign = signs(:one)
    slide.signs << sign unless slide.signs.include?(sign)
    sign_updated = sign.updated_at
    slide.save
    assert_not_equal(sign_updated, sign.reload.updated_at)
  end

  test 'duration must be larger than 4 seconds' do
    slide = slides(:one)
    slide.duration = 4
    assert_not slide.valid?
  end
end
