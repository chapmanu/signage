class SlidesController < ApplicationController
  include Ownable

  layout 'admin', except: [:preview]

  skip_before_action :authenticate_user!, only: [:preview]

  before_action :set_slide,                  only: [:draft, :show, :edit, :update, :send_to_sign, :destroy]
  before_action :set_slide_or_draft,         only: [:preview]
  before_action :set_signs,                  only: [:index, :new, :edit, :create, :update]
  before_action :set_parent_sign_path,       only: [:new, :edit]
  before_action :set_search_filters,         only: [:index]

  load_and_authorize_resource


  # GET /slides
  # GET /slides.json
  def index
    query = Slide.includes(:signs).nondraft
    query = query.owned_by(current_user) if params['filter'] == 'mine'
    if params['sort'] == 'popular'
      query = query.popular
    elsif params['sort'] == 'alpha'
      query = query.alpha
    else
      query = query.newest
    end
    @slides = query.search(params[:search]).page params[:page]
  end

  # GET /slides/1
  # GET /slides/1.json
  def show
  end

  def preview
  end

  def draft
    @draft = @slide.find_or_create_draft
    @draft.scheduled_items.clear

    # This will error if there are any nested scheduled items in slide_params. (See
    # https://github.com/chapmanu/signage/issues/147.) It will look up scheduled_items using
    # draft_id (negative) but scheduled_items are associated with proper ID.
    # (Is this why scheduled_items are cleared above?)
    filtered_params = slide_params.except('scheduled_items_attributes')

    @draft.update(filtered_params)
    @draft.signs.clear
    render nothing: true
  end

  # GET /slides/new
  def new
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
        @slide.create_activity(:create, owner: current_user, parameters: { name: @slide.menu_name })
        current_user.slides << @slide
        format.html { redirect_to edit_slide_path(@slide) }
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
        @slide.create_activity(:update, owner: current_user, parameters: { name: @slide.menu_name })
        format.html { redirect_to @slide, notice: 'Slide was successfully updated.' }
        format.json { render :show, status: :ok, location: @slide }
      else
        format.html { render :edit }
        format.json { render json: @slide.errors, status: :unprocessable_entity }
      end
    end
  end

  def send_to_sign
    ids = params[:slide][:sign_ids]
    UpdateSlide.execute(@slide, {sign_ids: ids}, current_user)
    redirect_to request.referrer, notice: 'Sent to signs.'
  end

  # DELETE /slides/1
  # DELETE /slides/1.json
  def destroy
    @slide.create_activity(:destroy, owner: current_user, parameters: { name: @slide.menu_name })
    @slide.destroy
    respond_to do |format|
      format.html { redirect_to slides_url, notice: 'Slide was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_slide
      @slide = Slide.nondraft.find(params[:id])
    end

    def set_slide_or_draft
      # I don't want the possibility of a draft being able to be edited or viewed.
      @slide = Slide.find(params[:id])
    end

    def set_signs
      query  = Sign.includes(:users)
      query  = query.visible_or_owned_by(current_user) unless current_user.super_admin?
      @signs = query.order(:name)
    end

    def set_parent_sign_path
      if name = request.referrer.to_s[/signs\/([^\/]+)/, 1]
        session[:parent_sign_id]   = Sign.friendly.find(name).id
        session[:parent_sign_path] = edit_sign_path(Sign.friendly.find(name))
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
      @owned_object = @slide = Slide.find(params[:id])
    end

    def set_search_filters
      SearchFilters.new(params, cookies, {
        filter: ['mine', 'all'],
        sort:   ['newest', 'popular', 'alpha']
      })
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
        :sponsor_id,
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