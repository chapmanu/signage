class AddThemeToSlides < ActiveRecord::Migration
  def change
    add_column :slides, :theme, :string
  end
end
