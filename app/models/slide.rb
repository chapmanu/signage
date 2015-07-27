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

  def template_partial
    template.to_s[/(\w+)\.mustache$/, 1].underscore
  end

  def background_url
    Rails.application.config.asset_url + background
  end

  def foreground_url
    Rails.application.config.asset_url + foreground
  end
end
