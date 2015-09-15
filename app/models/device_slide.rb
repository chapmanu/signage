class DeviceSlide < ActiveRecord::Base
  belongs_to :device
  belongs_to :slide
end