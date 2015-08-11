class Slide < ActiveRecord::Base
  belongs_to :device, touch: true
  has_many :scheduled_items, dependent: :destroy
  has_and_belongs_to_many :people

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

  def slug
    "#{id}-#{short_name}".parameterize
  end

  def short_name
    name[/\w+$/]
  end

  def people_slide?
    !!(template.downcase =~ /directory/)
  end

  def schedule_slide?
    !!(template.downcase =~ /schedule/)
  end

  def css_classes
    classes = ['ui-slide']
    classes << 'ui-slide--standard'       if layout =~ /standard/
    classes << 'ui-slide--directory'      if layout =~ /directory/
    classes << 'ui-slide--schedule'       if layout =~ /schedule/
    classes << 'ui-slide--right'          if variation =~ /right/
    classes << 'ui-slide--left'           if variation =~ /left/
    classes << 'ui-slide--dark'           if variation =~ /dark/
    classes << 'ui-slide--light'          if variation =~ /light/
    classes << 'ui-slide--has-background' if !background.blank?
    classes.join(' ')
  end

  def variation
    normalized_template[:variation]
  end

  def background_url
    Rails.application.config.asset_url + background
  end

  def foreground_url
    Rails.application.config.asset_url + foreground
  end

  private
    def normalized_template
      array = template.to_s[/(\w+)\.mustache$/, 1].underscore.split('_')
      { layout: array.shift, variation: array.join('_') }
    end
end
