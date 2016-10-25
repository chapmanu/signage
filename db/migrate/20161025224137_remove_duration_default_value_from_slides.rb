class RemoveDurationDefaultValueFromSlides < ActiveRecord::Migration
  # Default will not be specified in model.
  def change
    change_column_default(:slides, :duration, nil)
  end
end
