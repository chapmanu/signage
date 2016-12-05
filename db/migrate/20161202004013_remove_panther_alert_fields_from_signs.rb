class RemovePantherAlertFieldsFromSigns < ActiveRecord::Migration
  def change
    remove_column :signs, :panther_alert, :string
    remove_column :signs, :panther_alert_detail, :string
  end
end
