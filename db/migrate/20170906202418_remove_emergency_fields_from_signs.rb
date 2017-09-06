#
# UP:   rake db:migrate
# DOWN: rake db:migrate:down VERSION=20170906202418
#
class RemoveEmergencyFieldsFromSigns < ActiveRecord::Migration
  def change
    remove_column :signs, :panther_alert, :string
    remove_column :signs, :panther_alert_detail, :string
    remove_column :signs, :emergency, :string
    remove_column :signs, :emergency_detail, :string
  end
end
