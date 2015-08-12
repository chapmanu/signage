class AddStartStopToSlides < ActiveRecord::Migration
  def change
    add_column :slides, :play_on, :datetime
    add_column :slides, :stop_on, :datetime
  end
end
