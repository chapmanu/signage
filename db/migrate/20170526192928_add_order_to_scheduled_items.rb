class AddOrderToScheduledItems < ActiveRecord::Migration
  def change
    add_column :scheduled_items, :order, :integer
  end
end
