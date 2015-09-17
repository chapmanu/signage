class DeviceSlide < ActiveRecord::Base
  belongs_to :device
  belongs_to :slide

  validates_uniqueness_of :slide_id, scope: [:device_id]
end