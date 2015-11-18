class SignUser < ActiveRecord::Base
  belongs_to :sign
  belongs_to :user

  validates_uniqueness_of :user_id, scope: [:sign_id]
end
