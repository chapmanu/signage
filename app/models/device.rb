class Device < ActiveRecord::Base
  has_many :device_slides
  has_many :slides, through: :device_slides

  scope :search, -> (search) { where("name ILIKE ?", "%#{search}%") if search }

  validates :name, presence: true

  extend FriendlyId
  friendly_id :name, use: :slugged

  def self.menus
    @_menus ||= Dir[Rails.root.join('app', 'views', 'devices', 'menus', '*.html.erb')].map {|f| f[/\/_(.*)\.html\.erb$/, 1]}.sort
  end

  def active_slides
    slides.shown.active
  end

  def directory_slides
    active_slides.where('template ILIKE ?', '%directory%')
  end

  def menu
    template.to_s[/(\w+)(\.mustache)?$/, 1].underscore
  end

  def emergency?
    !emergency.blank? || !emergency_detail.blank?
  end
end