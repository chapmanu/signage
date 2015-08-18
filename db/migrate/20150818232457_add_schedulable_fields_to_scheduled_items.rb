class AddSchedulableFieldsToScheduledItems < ActiveRecord::Migration
  def change
    add_column :scheduled_items, :play_on, :datetime
    add_column :scheduled_items, :stop_on, :datetime
  end
end
