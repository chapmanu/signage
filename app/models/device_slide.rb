class DeviceSlide < ActiveRecord::Base
  belongs_to :device
  belongs_to :slide
  default_scope { order(:order) }
end