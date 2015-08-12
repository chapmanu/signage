class RemoveDatetimeFromSlides < ActiveRecord::Migration
  def change
    remove_column :slides, :datetime, :string
  end
end
