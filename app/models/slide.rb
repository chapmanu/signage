class Slide < ActiveRecord::Base
  has_and_belongs_to_many :devices
  has_and_belongs_to_many :people
  has_many :scheduled_items, dependent: :destroy

  after_save :touch_devices

  scope :shown,  -> { where(show: true) }
  scope :active, -> { where('slides.play_on IS NULL OR slides.play_on <= ?', Time.zone.now).where('slides.stop_on IS NULL OR slides.stop_on >= ?', Time.zone.now) }

  def self.templates
    @templates ||= Dir[Rails.root.join('app', 'views', 'slides', 'templates', '*.html.erb')].map {|f| f[/\/_(.*)\.html\.erb$/, 1]}
  end

  def self.themes
    @_themes ||= ['dark', 'light'] # It's always the darkest before light
  end

  def self.layouts
    @_layouts ||= ['left', 'right'] # We are in America peeps, left then right
  end

  def self.directory_feeds
    @_directory_feeds ||= ['Beckman Hall', 'Moulton Hall', 'Musco Center for the Arts']
  end

  def self.organizers
    @_organizers ||= ['CES', 'Dodge', 'Stuff', 'Yeah!'] # Read all the file names of the image files
  end

  def self.background_types
    @_background_types ||= ['none', 'image', 'video']
  end

  def self.foreground_types
    @_foreground_types ||= ['none', 'image', 'video']
  end

  def self.foreground_sizings
    @_foreground_sizings ||= ['exact size', 'fill screen', 'fill screen (do not crop)']
  end

  def active?
    !upcoming? && !expired?
  end

  def upcoming?
    !(play_on.nil? || play_on <= Time.zone.now)
  end

  def expired?
    !(stop_on.nil? || stop_on >= Time.zone.now)
  end

  def slug
    "#{id}-#{menu_name}".parameterize
  end

  def people_slide?
    !!(template.downcase =~ /directory/)
  end

  def schedule_slide?
    !!(template.downcase =~ /schedule/)
  end

  def css_classes
    classes = ['ui-slide']
    classes << 'ui-slide--standard'       if template =~ /standard/
    classes << 'ui-slide--directory'      if template =~ /directory/
    classes << 'ui-slide--schedule'       if template =~ /schedule/
    classes << 'ui-slide--right'          if layout =~ /right/
    classes << 'ui-slide--left'           if layout =~ /left/
    classes << 'ui-slide--dark'           if theme =~ /dark/
    classes << 'ui-slide--light'          if theme =~ /light/
    classes << 'ui-slide--has-background' if !background.blank?
    classes.join(' ')
  end

  def background_url
    Rails.application.config.asset_url + background
  end

  def foreground_url
    Rails.application.config.asset_url + foreground
  end

  private
    def touch_devices
      devices.update_all(updated_at: Time.now)
    end
end
