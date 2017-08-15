class SwapColumnNames < ActiveRecord::Migration
  def change
  	rename_column :scheduled_items, :admission, :admission_temp
  	rename_column :scheduled_items, :audience, :admission
  	rename_column :scheduled_items, :admission_temp, :audience
  end
end
