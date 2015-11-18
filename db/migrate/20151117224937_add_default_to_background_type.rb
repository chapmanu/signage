class AddDefaultToBackgroundType < ActiveRecord::Migration
  def up
    change_column :slides, :background_type, :string, default: 'none'
    change_column :slides, :foreground_type, :string, default: 'none'
  end

  def down
    change_column :slides, :background_type, :string
    change_column :slides, :foreground_type, :string
  end
end
