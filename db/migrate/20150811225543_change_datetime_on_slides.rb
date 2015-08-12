class ChangeDatetimeOnSlides < ActiveRecord::Migration
  def up
    change_column :slides, :datetime, :string
  end

  def down
    change_column :slides, :datetime, :datetime
  end
end
