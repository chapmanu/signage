class SlidesController < ApplicationController
  before_action :set_slide,              only: [:preview, :show, :edit, :update, :destroy]
  before_action :set_devices,            only: [:new, :edit]
  before_action :set_parent_device_path,   only: [:new, :edit]
  layout 'admin', except: [:preview]

  def preview
  end

  def live_preview
    @slide = Slide.new(slide_params)
    render :preview, layout: 'application'
  rescue ActionView::Template::Error
    render status: :unprocessable_entity, nothing: true
  end

  # GET /slides
  # GET /slides.json
  def index
    @slides = Slide.all
  end

  # GET /slides/1
  # GET /slides/1.json
  def show
  end

  # GET /slides/new
  def new
    @slide = Slide.new
    device = Device.friendly.find(session[:parent_device_id]) if session[:parent_device_id]
    @slide.devices << device if device
  end

  # GET /slides/1/edit
  def edit
  end

  # POST /slides
  # POST /slides.json
  def create
    @slide = Slide.new(slide_params)

    respond_to do |format|
      if @slide.save
        format.html { redirect_to @slide, notice: 'Slide was successfully created.' }
        format.json { render :show, status: :created, location: @slide }
      else
        format.html { render :new }
        format.json { render json: @slide.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /slides/1
  # PATCH/PUT /slides/1.json
  def update
    respond_to do |format|
      if @slide.update(slide_params)
        format.html { redirect_to @slide, notice: 'Slide was successfully updated.' }
        format.json { render :show, status: :ok, location: @slide }
      else
        format.html { render :edit }
        format.json { render json: @slide.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /slides/1
  # DELETE /slides/1.json
  def destroy
    @slide.destroy
    respond_to do |format|
      format.html { redirect_to slides_url, notice: 'Slide was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_slide
      @slide = Slide.find(params[:id])
    end

    def set_devices
      @devices = Device.all.order(:name)
    end

    def set_parent_device_path
      if id = request.referrer.to_s[/devices\/([^\/]+)\/.*/, 1]
        session[:parent_device_id]   = id
        session[:parent_device_path] = edit_device_path(id)
      else
        session[:parent_device_id]   = nil
        session[:parent_device_path] = nil
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def slide_params
      params.require(:slide).permit(
        :name,
        :template,
        :theme,
        :layout,
        :play_on,
        :stop_on,
        :show,
        :directory_feed,
        :menu_name,
        :organizer,
        :organizer_id,
        :duration,
        :heading,
        :subheading,
        :datetime,
        :location,
        :content,
        :background,
        :background_type,
        :background_sizing,
        :foreground,
        :foreground_type,
        :foreground_sizing,
        :device_ids => []
        )
    end
end