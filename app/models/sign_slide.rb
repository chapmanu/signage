class SignSlide < ActiveRecord::Base
  belongs_to :sign
  belongs_to :slide, counter_cache: :signs_count

  validates_uniqueness_of :slide_id, scope: [:sign_id]

  scope :awaiting_approval, -> do
    includes(:slide)
    .where(approved: false)
    .where.not(slides: {stop_on: nil})
    .where('slides.stop_on < ?', Time.zone.now)
  end
end