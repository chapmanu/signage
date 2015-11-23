class SlidesController < ApplicationController
  include Ownable

  before_action :set_slide,                  only: [:preview, :show, :edit, :update, :destroy]
  before_action :set_signs,                  only: [:new, :edit, :create, :update]
  before_action :set_parent_sign_path,       only: [:new, :edit]

  skip_before_action :authenticate_user!, only: [:preview]

  layout 'admin', except: [:preview]

  # GET /slides
  # GET /slides.json
  def index
    query = Slide.includes(:signs)
    query = query.owned_by(current_user) if params['filter'] == 'mine'
    if params['sort'] == 'popular'
      query = query.popular
    elsif params['sort'] == 'alpha'
      query = query.alpha
    else
      query = query.newest
    end
    @signs  = Sign.order(:name)
    @slides = query.search(params[:search]).page params[:page]
  end

  # GET /slides/1
  # GET /slides/1.json
  def show
  end

  def preview
  end

  def live_preview
    @slide = params[:id].blank? ? Slide.new : Slide.find(params[:id])
    @slide.attributes = slide_params

    @slide.remove_background! if slide_params[:remove_background] == '1'
    @slide.remove_foreground! if slide_params[:remove_foreground] == '1'

    render :preview, layout: 'application'
  rescue ActionView::Template::Error
    render status: :unprocessable_entity, nothing: true
  end

  # GET /slides/new
  def new
    @slide = Slide.new
    sign = Sign.friendly.find(session[:parent_sign_id]) if session[:parent_sign_id]
    @slide.signs << sign if sign
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
        @slide.take_screenshot
        current_user.add_slide(@slide)
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
      if UpdateSlide.execute(@slide, slide_params, current_user)
        @slide.take_screenshot
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

    def set_signs
      @signs = Sign.includes(:users).order(:name)
    end

    def set_parent_sign_path
      if id = request.referrer.to_s[/signs\/([^\/]+)/, 1]
        session[:parent_sign_id]   = id
        session[:parent_sign_path] = edit_sign_path(id)
      else
        session[:parent_sign_id]   = nil
        session[:parent_sign_path] = nil
      end
    end

    def lookup_in_active_directory
      User.create_or_update_from_active_directory(params[:term])
    rescue UnexpectedActiveDirectoryFormat
    end

    def set_owned_object
      @owned_object = Slide.find(params[:id])
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
        :building_name,
        :menu_name,
        :organizer,
        :organizer_id,
        :duration,
        :heading,
        :subheading,
        :datetime,
        :location,
        :content,
        :feed_url,
        :background,
        :background_type,
        :background_sizing,
        :remove_background,
        :foreground,
        :foreground_type,
        :foreground_sizing,
        :background_cache,
        :foreground_cache,
        :remove_foreground,
        :sign_ids => [],
        :scheduled_items_attributes => [
          :id,
          :_destroy,
          :date,
          :time,
          :image,
          :content,
          :admission,
          :audience,
          :image_cache,
          :remove_image,
          :name,
          :play_on,
          :stop_on
        ]
        )
    end
end