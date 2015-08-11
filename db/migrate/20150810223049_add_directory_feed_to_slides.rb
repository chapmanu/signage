class AddDirectoryFeedToSlides < ActiveRecord::Migration
  def change
    add_column :slides, :directory_feed, :string
  end
end
