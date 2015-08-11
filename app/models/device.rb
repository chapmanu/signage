class Device < ActiveRecord::Base
  has_and_belongs_to_many :slides

  def self.menus
    @_menus ||= Dir[Rails.root.join('app', 'views', 'devices', 'menus', '*.html.erb')].map {|f| f[/\/_(.*)\.html\.erb$/, 1]}
  end

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
