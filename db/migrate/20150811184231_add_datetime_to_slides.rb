class AddDatetimeToSlides < ActiveRecord::Migration
  def change
    add_column :slides, :datetime, :datetime
  end
end
