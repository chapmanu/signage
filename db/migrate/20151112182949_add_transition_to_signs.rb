class AddTransitionToSigns < ActiveRecord::Migration
  def change
    add_column :signs, :transition, :string
  end
end
