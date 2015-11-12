class SignSlide < ActiveRecord::Base
  belongs_to :sign
  belongs_to :slide

  validates_uniqueness_of :slide_id, scope: [:sign_id]
end