class RemoveDeviceIdFromSlides < ActiveRecord::Migration
  def change
    remove_column :slides, :device_id, :integer
  end
end
