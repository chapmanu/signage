class SignsController < ApplicationController
  include Ownable

  layout 'admin', except: [:play]

  skip_before_action :authenticate_user!, only: [:play, :poll]

  before_action :set_sign, only: [:remove_slide, :poll, :show, :edit, :update, :destroy, :play, :settings, :order]
  before_action :set_search_filters, only: [:index]

  load_and_authorize_resource except: [:play, :poll]

  # GET /signs
  # GET /signs.json
  def index
    query = Sign.eager_load(:slides)

    if params['filter'] == 'mine'
      query = query.owned_by(current_user)
    elsif !current_user.super_admin?
      query = query.visible_or_owned_by(current_user)
    end

    @signs = query.search(params['search']).order(:name)
  end

  # GET /signs/1
  # GET /signs/1.json
  def show
    @unexpired_slides = @sign.sign_slides.order(:order).eager_load(:slide).select do |slide|
      !Slide.find(slide.slide_id).expired?
    end
  end

  # GET /signs/1/play
  def play
  end

  # GET /signs/new
  def new
    @sign = Sign.new
  end

  # GET /signs/1/edit
  def edit
  end

  # POST /signs
  # POST /signs.json
  def create
    @sign = Sign.new(sign_params)

    respond_to do |format|
      if @sign.save
        @sign.create_activity(:create, owner: current_user, parameters: { name: @sign.name })
        current_user.signs << @sign
        format.html { redirect_to @sign; flash[:notice] = 'Sign was successfully created.' }
        format.json { render :show, status: :created, location: @sign }
      else
        format.html { render :new }
        format.json { render json: @sign.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /signs/1
  # PATCH/PUT /signs/1.json
  def update
    respond_to do |format|
      if @sign.update(sign_params)
        @sign.create_activity(:update, owner: current_user, parameters: { name: @sign.name })
        format.html { redirect_to @sign; flash[:notice] = 'Sign was successfully updated.' }
        format.json { render :show, status: :ok, location: @sign }
      else
        format.html { render :edit }
        format.json { render json: @sign.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /signs/1
  # DELETE /signs/1.json
  def destroy
    @sign.create_activity(:destroy, owner: current_user, parameters: { name: @sign.name })
    @sign.destroy
    respond_to do |format|
      format.html { redirect_to signs_url, notice: 'Sign was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def order
    params[:sign_slide_ids].each_with_index do |id, index|
      SignSlide.find(id).update(order: index+1)
    end
    @sign.touch
    render nothing: true
  end

  def remove_slide
    @slide = Slide.find(params[:slide_id])
    @sign.slides.delete(@slide)
  end

  def poll
    # This is the endpoint play page polls in background to monitor for emergencies or sign
    # updates.
    @sign.touch_last_ping
    last_updated = Time.zone.parse(sign_params[:updated_at])
    @refresh = @sign.updated_at.to_i > last_updated.to_i
  end

  def set_search_filters
    SearchFilters.new(params, cookies, {filter: ['mine', 'all']})
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sign
      @sign = Sign.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sign_params
      params.require(:sign).permit(:name, :template, :transition, :visibility, :location, :emergency, :emergency_detail, :updated_at, user_ids: [])
    end

    def set_owned_object
      @owned_object = @sign = Sign.friendly.find(params[:id])
    end
end