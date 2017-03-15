class AddOrientationToSlides < ActiveRecord::Migration
  def change
    add_column :slides, :orientation, :integer, default: 0
  end
end
