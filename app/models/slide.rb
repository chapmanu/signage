class Slide < ActiveRecord::Base
  has_many :device_slides, dependent: :destroy
  has_many :devices, through: :device_slides
  has_and_belongs_to_many :people
  has_many :scheduled_items, dependent: :destroy

  after_save :touch_devices

  scope :search, -> (search) { where("name ILIKE ?", "%#{search}%") if search }
  scope :shown,  -> { where(show: true) }

  mount_uploader :background, ImageUploader
  mount_uploader :foreground, ImageUploader

  validates :menu_name, presence: true
  validates :template,  presence: true

  include SlideFormOptions
  include Schedulable

  accepts_nested_attributes_for :scheduled_items, allow_destroy: true

  paginates_per 10

  def people_slide?
    !!(template.downcase =~ /directory/)
  end

  def schedule_slide?
    !!(template.downcase =~ /schedule/)
  end

  def slug
    id.to_s
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

  private
    def touch_devices
      devices.update_all(updated_at: Time.now)
    end
end
