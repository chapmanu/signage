class Slide < ActiveRecord::Base
  belongs_to :device
  has_many :scheduled_items, dependent: :destroy
  has_and_belongs_to_many :people

  def slug
    "#{id.to_s}-#{name[/\w+$/]}".parameterize
  end

  def people_slide?
    !!(template.downcase =~ /directory/)
  end

  def schedule_slide?
    !!(template.downcase =~ /schedule/)
  end

  def layout
    normalized_template[:layout]
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
