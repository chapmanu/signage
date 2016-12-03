class Sign < ActiveRecord::Base
  has_many :sign_users
  has_many :users, through: :sign_users, dependent: :destroy, prevent_dups: true

  has_many :sign_slides
  has_many :slides, through: :sign_slides, dependent: :destroy, prevent_dups: true

  scope :search, -> (search) { where("signs.name ILIKE ?", "%#{search}%") if search.present? }
  scope :owned_by, -> (user) { joins(:sign_users).where('sign_users.user_id' => user.id) }

  validates :name, presence: true

  extend FriendlyId
  friendly_id :name, use: :slugged

  include PublicActivity::Common

  include OwnableModel

  alias_method :owners, :users

  # Virtual Fields
  attr_accessor :campus_alert_feed  # See setter below for details.

  after_initialize do |sign|
    sign.campus_alert_feed = Rails.configuration.x.campus_alert.feed
  end

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
    emergency? || campus_alert?
  end

  def emergency?
    [emergency, emergency_detail].any? do |field|
      !field.blank?
    end
  end

  def campus_alert?
    campus_alerts.length > 0
  end

  def latest_campus_alert
    campus_alert? ? campus_alerts.first : nil
  end

  def touch_last_ping
    update_column(:last_ping, Time.zone.now)
  end

  def active?
    last_ping && (Time.zone.now - 8.seconds) <= last_ping  # The poll is every 5 seconds (3 second delay is fine)
  end

  def campus_alert_feed=(url)
    # Virtual field that can be set dynamically in non-production environment to switch campus
    # alerts feed URL for test/demo purposes.
    #
    # The alerts_feed param can be attached as a query string param to the play URL in order to
    # set a test feed for any non-production environment:
    # /signs/test-sign/play?alerts-feed=http://localhost:3000/mock/campus_alerts_feed/emergency
    if url && Rails.env.staging?
      @campus_alert_feed = url
    else
      @campus_alert_feed = Rails.configuration.x.campus_alert.feed
    end
  end

  private

  def campus_alerts
    # Check cache then campus alert feed.
    Rails.cache.fetch('campus-alerts-feed', expires_in: 60.seconds) do
      response = RestClient.get campus_alert_feed
      data = Hash.from_xml(response)
      items = data["rss"]["channel"]["item"]

      # If multiple items, then items is an array of hashes, else a single hash
      messages = items.is_a?(Array) ? items : [items]

      # TODO: Verify the alert flag with Public Safety. In the sample feed provided, there
      # is a default "everything is fine" message when no alerts. At this time, we are not yet
      # sure exactly what an alert would look like, but we understand that it is user-generated.
      messages.keep_if {|message| message['category'].upcase == 'EMERGENCY'}
    end
  end
end