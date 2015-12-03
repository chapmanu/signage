class Slide < ActiveRecord::Base
  include UniqueHasManyThrough
  unique_has_many_through :signs, :sign_slides
  unique_has_many_through :users, :slide_users

  has_many :scheduled_items, dependent: :destroy

  after_save :touch_signs

  include PublicActivity::Common

  scope :search,   -> (search) { where("slides.menu_name ILIKE ?", "%#{search}%") if search.present? }
  scope :shown,    -> { where("slides.show" => true) }
  scope :approved, -> { where("sign_slides.approved" => true)}
  scope :ordered,  -> { order("sign_slides.order") }
  scope :owned_by, -> (user) { includes(:slide_users).where('slide_users.user_id' => user.id) }
  scope :popular,  -> { order(signs_count: :desc, menu_name: :asc) }
  scope :newest,   -> { order(created_at: :desc) }
  scope :alpha,    -> { order(menu_name: :asc) }

  mount_uploader :background, ImageUploader
  mount_uploader :foreground, ImageUploader
  mount_uploader :screenshot, ImageUploader

  validates :menu_name, presence: true
  validates :template,  presence: true
  validates :duration,  numericality: { greater_than_or_equal_to: 5 }

  include SlideFormOptions
  include Schedulable
  include OwnableModel

  accepts_nested_attributes_for :scheduled_items, allow_destroy: true

  paginates_per 24

  def people_slide?
    !!(template.downcase =~ /directory/)
  end

  def schedule_slide?
    !!(template.downcase =~ /schedule/)
  end

  def slug
    id.to_s
  end

  def hide?
    !show?
  end

  def status
    return 'hidden'   if hide?
    return 'active'   if active?
    return 'upcoming' if upcoming?
    return 'expired'  if expired?
  end

  def css_classes
    classes = ['ui-slide']
    classes << 'ui-slide--standard'       if template =~ /standard/
    classes << 'ui-slide--directory'      if template =~ /directory/
    classes << 'ui-slide--schedule'       if template =~ /schedule/
    classes << 'ui-slide--social_feed'    if template =~ /social_feed/
    classes << 'ui-slide--right'          if layout =~ /right/
    classes << 'ui-slide--left'           if layout =~ /left/
    classes << 'ui-slide--dark'           if theme =~ /dark/
    classes << 'ui-slide--light'          if theme =~ /light/
    classes << 'ui-slide--has-background' if !background.blank?
    classes.join(' ')
  end

  def take_screenshot
    if (Rails.env.test? || Rails.env.development?)
      self.screenshot = File.open(Rails.root.join('app/assets/images/dev-screenshot.jpg'))
      save!
    else
      f = Screencap::Fetcher.new(Rails.application.routes.url_helpers.preview_slide_url(self))
      file  = f.fetch output: Rails.root.join('tmp', "screenshot_of_slide_#{id}.png")
      image = MiniMagick::Image.open(file)
      image.trim
      self.screenshot = image
      save!
      File.delete(file)
    end
  end

  private
    def touch_signs
      signs.update_all(updated_at: Time.now)
    end
end
