class DeviceUser < ActiveRecord::Base
  belongs_to :device
  belongs_to :user

  validates_uniqueness_of :user_id, scope: [:device_id]
end
