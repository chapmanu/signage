class PersonSlide < ActiveRecord::Base
  belongs_to :person
  belongs_to :slide

  validates_uniqueness_of :slide_id, :scope => :person_id, :message => "duplicate people not allowed"
end