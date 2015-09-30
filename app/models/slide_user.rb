class SlideUser < ActiveRecord::Base
  belongs_to :slide
  belongs_to :user

  validates_uniqueness_of :user_id, scope: [:slide_id]
end