class Device < ActiveRecord::Base
  has_many :slides

  def to_param
    name
  end
end
