class ScheduledItem < ActiveRecord::Base
  belongs_to :slide, touch: true

  mount_uploader :image, ImageUploader

  include Schedulable

  def image_url
    Rails.application.config.asset_url + image
  end
end
