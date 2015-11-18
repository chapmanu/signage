class AddScreenshotToSlides < ActiveRecord::Migration
  def change
    add_column :slides, :screenshot, :string
  end
end
