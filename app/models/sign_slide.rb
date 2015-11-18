class SignSlide < ActiveRecord::Base
  belongs_to :sign
  belongs_to :slide, counter_cache: :signs_count

  validates_uniqueness_of :slide_id, scope: [:sign_id]
end