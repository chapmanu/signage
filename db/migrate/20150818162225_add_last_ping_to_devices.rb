class AddLastPingToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :last_ping, :datetime
  end
end
