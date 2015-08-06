class Device < ActiveRecord::Base
  has_many :slides

  def directory_slides
    slides.where('template ILIKE ?', '%directory%')
  end

  def menu
    template.to_s[/(\w+)(\.mustache)?$/, 1].underscore
  end

  def to_param
    name
  end

  def emergency?
    !emergency.blank? || !emergency_detail.blank?
  end
end
