class Sign < ActiveRecord::Base
  has_many :sign_users
  has_many :users, through: :sign_users, dependent: :destroy, prevent_dups: true

  has_many :sign_slides
  has_many :slides, through: :sign_slides, dependent: :destroy, prevent_dups: true

  enum visibility: { listed: 0, hidden: 1 }

  scope :search, -> (search) { where("signs.name ILIKE ?", "%#{search}%") if search.present? }
  scope :owned_by, -> (user) { joins(:sign_users).where('sign_users.user_id' => user.id) }
  
  validates :name, presence: true

  extend FriendlyId
  friendly_id :name, use: :slugged

  include PublicActivity::Common

  include OwnableModel

  alias_method :owners, :users

  def self.menus
    @_menus ||= Dir[Rails.root.join('app', 'views', 'signs', 'menus', '*.html.erb')].map {|f| f[/\/_(.*)\.html\.erb$/, 1]}.sort
  end

  def self.transitions
    @_transitions ||= ['fade', 'swipe', 'drop', 'rotate']
  end

  def playable_slides
    slides.shown.active.approved.ordered
  end

  def directory_slides
    playable_slides.where('template ILIKE ?', '%directory%')
  end

  def menu
    template.to_s[/(\w+)(\.mustache)?$/, 1].underscore
  end

  def any_emergency?
    emergency? || panther_alert?
  end

  def emergency?
    [emergency, emergency_detail].any? do |field|
      !field.blank?
    end
  end

  def panther_alert?
    [panther_alert, panther_alert_detail].any? do |field|
      !field.blank?
    end
  end

  def touch_last_ping
    update_column(:last_ping, Time.zone.now)
  end

  def active?
    last_ping && (Time.zone.now - 8.seconds) <= last_ping  # The poll is every 5 seconds (3 second delay is fine)
  end
end