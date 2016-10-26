class RemoveDurationDefaultValueFromSlides < ActiveRecord::Migration
  # Default for duration will be set in model.
  def change
    change_column_default(:slides, :duration, nil)
  end
end
