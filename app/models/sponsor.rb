class Sponsor < ActiveRecord::Base
  has_many :slides, dependent: :destroy

  default_scope { order(:name) }

end