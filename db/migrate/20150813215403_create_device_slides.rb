class CreateDeviceSlides < ActiveRecord::Migration
  def change
    create_table :device_slides do |t|
      t.integer :order
      t.belongs_to :device, index: true, foreign_key: true
      t.belongs_to :slide, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
