class Slide < ActiveRecord::Base
  attr_accessor :skip_file_validation
  has_many :sign_slides
  has_many :signs, through: :sign_slides, dependent: :destroy, prevent_dups: true

  has_many :slide_users
  has_many :users, through: :slide_users, dependent: :destroy, prevent_dups: true

  has_many :scheduled_items, dependent: :destroy

  belongs_to :sponsor

  after_save :touch_signs

  include PublicActivity::Common

  scope :nondraft, -> { where('slides.id > 0') }
  scope :search,   -> (search) { where("slides.menu_name ILIKE ?", "%#{search}%") if search.present? }
  scope :owned_by, -> (user) { includes(:slide_users).where('slide_users.user_id' => user.id) }
  scope :shown,    -> { where("slides.show" => true) }
  scope :approved, -> { where("sign_slides.approved" => true)}
  scope :ordered,  -> { order("sign_slides.order") }
  scope :popular,  -> { order(signs_count: :desc, menu_name: :asc) }
  scope :newest,   -> { order(created_at: :desc) }
  scope :alpha,    -> { order(menu_name: :asc) }

  mount_uploader :background, ImageUploader
  mount_uploader :foreground, ImageUploader
  mount_uploader :screenshot, ImageUploader

  validates :menu_name, presence: true
  validates :template,  presence: true
  validates :duration,  numericality: { greater_than_or_equal_to: 5 }
  validate  :file_size, on: :update

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
    classes << 'ui-slide--left'           if layout =~ /left/
    classes << 'ui-slide--dark'           if theme =~ /dark/
    classes << 'ui-slide--light'          if theme =~ /light/
    classes << 'ui-slide--has-background' if !background.blank?
    classes.join(' ')
  end

  def take_screenshot(opt = false)
    @skip_file_validation = opt
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

  def file_size
    if !@skip_file_validation
      if foreground_type.present? && foreground_type != 'none'
        self.send("#{foreground_type}_file", 'foreground' , {width: 912, height: 1080})
      end

      if background_type.present? && background_type != 'none'
        self.send("#{background_type}_file", 'background', {width: 1920, height: 1080})
      end
    else
      @skip_file_validation = false
    end
  end

  private
    def touch_signs
      signs.update_all(updated_at: Time.now)
    end

    def video_file(type, opts = nil)
      video = File.open(self.send("#{type}").file.path)

      if video.size > 12.megabytes
        errors.add("#{type} Video: ", 'You cannot upload a video larger than 12 MB')
      end
    end

    def image_file(type, opts = nil)
      file = MiniMagick::Image.open(self.send("#{type}").file.path)

      if file.width > opts[:width] || file.height > opts[:height]
        errors.add("#{type} Image: ", "You cannot upload a #{type} image that is larger than #{opts[:width]}x#{opts[:height]}")
      end
    end
end