class Device < ActiveRecord::Base
  has_many :device_slides, dependent: :destroy
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

  def touch_last_ping
    update_column(:last_ping, Time.zone.now)
  end

  def active?
    last_ping && (Time.zone.now - 8.seconds) <= last_ping  # The poll is every 5 seconds (3 second delay is fine)
  end
end