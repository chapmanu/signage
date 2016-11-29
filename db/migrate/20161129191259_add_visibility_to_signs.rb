class AddVisibilityToSigns < ActiveRecord::Migration
  def change
    add_column :signs, :visibility, :integer, default: 0
  end
end
