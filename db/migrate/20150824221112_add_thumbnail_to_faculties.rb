class AddThumbnailToFaculties < ActiveRecord::Migration
  def change
    add_column :faculties, :thumbnail, :string
  end
end
