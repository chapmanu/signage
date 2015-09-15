class CreateDeviceUsers < ActiveRecord::Migration
  def change
    create_table :device_users do |t|
      t.belongs_to :device, index: true, foreign_key: true
      t.belongs_to :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
