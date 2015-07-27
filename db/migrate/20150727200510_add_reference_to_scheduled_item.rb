class AddReferenceToScheduledItem < ActiveRecord::Migration
  def change
    add_reference :scheduled_items, :slide, index: true, foreign_key: true
  end
end
