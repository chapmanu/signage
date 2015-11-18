class RenameDeviceToSign < ActiveRecord::Migration
  def change
    rename_table :devices, :signs
    rename_table :device_slides, :sign_slides
    rename_table :device_users, :sign_users

    rename_column :sign_slides, :device_id, :sign_id
    rename_column :sign_users, :device_id, :sign_id
  end
end
