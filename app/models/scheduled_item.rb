class ScheduledItem < ActiveRecord::Base
  include Schedulable

  belongs_to :slide, touch: true

  mount_uploader :image, ImageUploader

  scope :ordered, -> { order(order: :asc) }

  def image_url
    Rails.application.config.asset_url + image
  end
end
