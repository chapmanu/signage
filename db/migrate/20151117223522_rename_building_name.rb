class RenameBuildingName < ActiveRecord::Migration
  def change
    rename_column :slides, :directory_feed, :building_name
  end
end
