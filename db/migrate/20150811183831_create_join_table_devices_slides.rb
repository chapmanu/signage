class CreateJoinTableDevicesSlides < ActiveRecord::Migration
  def change
    create_join_table :devices, :slides do |t|
      t.index [:device_id, :slide_id]
      t.index [:slide_id, :device_id]
    end
  end
end
