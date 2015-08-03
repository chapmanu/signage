class Device < ActiveRecord::Base
  has_many :slides

  def directory_slides
    slides.where('template ILIKE ?', '%directory%')
  end

  def to_param
    name
  end
end
