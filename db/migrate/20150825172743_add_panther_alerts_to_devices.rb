class AddPantherAlertsToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :panther_alert, :string
    add_column :devices, :panther_alert_detail, :string
  end
end
