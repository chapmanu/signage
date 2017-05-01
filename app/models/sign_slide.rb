class SignSlide < ActiveRecord::Base
  belongs_to :sign
  belongs_to :slide, counter_cache: :signs_count

  validates_uniqueness_of :slide_id, scope: [:sign_id]

  scope :awaiting_approval, -> do
    joins(:slide)
    .where(approved: false)
    .where('slides.stop_on IS NULL OR slides.stop_on > ?', Time.zone.now)
    .order('slides.stop_on ASC')
  end
  scope :unexpired, -> do
    eager_load(:slide)
    .where('slides.stop_on IS NULL OR slides.stop_on > ?', Time.zone.now)
    .order(:order)
  end

  def self.awaiting_approval_by_sign_owner(sign_owner)
    awaiting_approval.joins(sign: :sign_users).where('sign_users.user_id' => sign_owner.id)
  end

end