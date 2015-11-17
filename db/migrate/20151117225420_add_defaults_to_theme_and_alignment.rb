class AddDefaultsToThemeAndAlignment < ActiveRecord::Migration
  def up
    change_column :slides, :layout, :string, default: 'left'
    change_column :slides, :theme, :string,  default: 'light'
  end

  def down
    change_column :slides, :layout, :string
    change_column :slides, :theme, :string
  end
end
