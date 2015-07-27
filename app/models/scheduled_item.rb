class ScheduledItem < ActiveRecord::Base
  belongs_to :slide

  def image_url
    Rails.application.config.asset_url + image
  end
end
