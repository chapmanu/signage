class AddDefaultsToSizing < ActiveRecord::Migration
  def up
    change_column :slides, :foreground_sizing, :string, default: 'cover'
  end

  def down
    change_column :slides, :foreground_sizing, :string
  end
end
