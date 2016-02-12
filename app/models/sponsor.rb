class Sponsor < ActiveRecord::Base
  has_many :slides, dependent: :nullify

  default_scope { order(:name) }

end