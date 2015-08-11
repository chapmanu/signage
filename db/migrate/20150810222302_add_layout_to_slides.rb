class AddLayoutToSlides < ActiveRecord::Migration
  def change
    add_column :slides, :layout, :string
  end
end
