class AddSignsCountToSlides < ActiveRecord::Migration
  def change
    add_column :slides, :signs_count, :integer, default: 0, null: false
  end
end
