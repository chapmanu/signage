class Person < ActiveRecord::Base
  has_and_belongs_to_many :slides, touch: true
end