class AddSocialFeedToSlides < ActiveRecord::Migration
  def change
    add_column :slides, :feed_url, :string
  end
end
