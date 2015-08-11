class AddShowToSlides < ActiveRecord::Migration
  def change
    add_column :slides, :show, :boolean
  end
end
