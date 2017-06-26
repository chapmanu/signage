class Slide < ActiveRecord::Base
  IMAGE_DIMENSIONS = {
    foreground: {width: 912, height: 1080},
    background: {width: 1920, height: 1080}
  }
  DEFAULT_DURATION = 10

  attr_accessor :skip_file_validation

  has_many :sign_slides
  has_many :signs, through: :sign_slides, dependent: :destroy, prevent_dups: true

  has_many :slide_users
  has_many :users, through: :slide_users, dependent: :destroy, prevent_dups: true

  # Adding order here just to clarify the default ordering. At present, users cannot reorder
  # scheduled items for a slide. If they need to, they'll need to create a new slide.
  has_many :scheduled_items, dependent: :destroy

  belongs_to :sponsor

  after_initialize :set_defaults, unless: :persisted?
  after_save :touch_signs

  include PublicActivity::Common

  scope :nondraft, -> { where('slides.id > 0') }
  scope :search,   -> (search) { where("slides.menu_name ILIKE ?", "%#{search}%") if search.present? }
  scope :owned_by, -> (user) { includes(:slide_users).where('slide_users.user_id' => user.id) }
  scope :shown,    -> { where("slides.show" => true) }
  scope :approved, -> { where("sign_slides.approved" => true) }
  scope :ordered,  -> { order("sign_slides.order") }
  scope :popular,  -> { order(signs_count: :desc, menu_name: :asc) }
  scope :newest,   -> { order(created_at: :desc) }
  scope :alpha,    -> { order(menu_name: :asc) }

  enum orientation: { horizontal: 0, vertical: 1 }

  mount_uploader :background, ImageUploader
  mount_uploader :foreground, ImageUploader
  mount_uploader :screenshot, ImageUploader

  validates :menu_name, presence: true
  validates :template,  presence: true
  validates :duration,  numericality: { greater_than_or_equal_to: 5 }
  validate  :validate_file_size, on: :update


  include SlideFormOptions
  include Schedulable
  include OwnableModel

  alias_method :owners, :users

  accepts_nested_attributes_for :scheduled_items, allow_destroy: true

  paginates_per 24

  def find_or_create_draft
    if draft = Slide.where(id: draft_id).first
      draft
    else
      draft = dup
      draft.update(id: draft_id)
      draft
    end
  end

  def draft_id
    -id
  end

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
    classes << 'ui-slide--center'         if layout =~ /center/
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

  def validate_file_size
    if !self.skip_file_validation
      validate_foreground_file
      validate_background_file
    else
      self.skip_file_validation = false
    end
  end


  private
    def set_defaults
      # Based on http://stackoverflow.com/a/29575389/6763239.
      self.duration ||= DEFAULT_DURATION
    end

    def touch_signs
      signs.update_all(updated_at: Time.now)
    end

    def validate_foreground_file
      if foreground_type.present? && foreground_type != 'none'
        self.send("validate_#{foreground_type}_file", 'foreground')
      end
    end

    def validate_background_file
      if background_type.present? && background_type != 'none'
        self.send("validate_#{background_type}_file", 'background')
      end
    end

    def validate_video_file(type, opts = nil)
      if !self.send("#{type}").file.nil?
        video = File.open(self.send("#{type}").file.path)
        if video.size > 12.megabytes
          errors.add("#{type} Video: ", 'You cannot upload a video larger than 12 MB')
        end
      else
        errors.add("#{type} Video: ","You must upload a valid video file.")
      end
    end

    def validate_image_file(type, opts = nil)
      if !self.send("#{type}").file.nil?
        file   = MiniMagick::Image.open(self.send("#{type}").file.path)
        width  = IMAGE_DIMENSIONS[type.to_sym][:width]
        height = IMAGE_DIMENSIONS[type.to_sym][:height]

        if file.width > width || file.height > height
          errors.add("#{type} Image: ", "You cannot upload a #{type} image that is larger than #{width}x#{height}")
        end
      else
        errors.add("#{type} Image: ","You must upload a valid image file.")
      end

    end
end