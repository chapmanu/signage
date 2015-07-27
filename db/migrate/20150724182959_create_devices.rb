class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :name
      t.string :template
      t.string :location
      t.string :notification
      t.string :notification_detail
      t.string :emergency
      t.string :emergency_detail

      t.timestamps null: false
    end
  end
end
