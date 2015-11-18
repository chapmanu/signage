class SignsController < ApplicationController
  before_action :set_sign, only: [:add_user, :remove_user, :poll, :show, :edit, :update, :destroy, :play, :settings]
  layout 'admin', except: [:play]
  skip_before_action :authenticate_user!, only: [:play, :poll]


  # GET /signs
  # GET /signs.json
  def index
    query  = Sign.eager_load(:slides)
    query  = query.owned_by(current_user) if params['filter'] == 'mine'
    @signs = query.search(params['search']).order(:name)
  end

  # GET /signs/1
  # GET /signs/1.json
  def show
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
    @sign.destroy
    respond_to do |format|
      format.html { redirect_to signs_url, notice: 'Sign was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def settings
  end

  def add_user
    @sign.add_user User.find(params[:user_id])
  end

  def remove_user
    @sign.remove_user User.find(params[:user_id])
  end

  def order
    params[:sign_slide_ids].each_with_index do |id, index|
      SignSlide.find(id).update(order: index)
    end
    render nothing: true
  end

  def poll
    @sign.touch_last_ping
    last_updated = Time.zone.parse(sign_params[:updated_at])
    @refresh = @sign.updated_at.to_i > last_updated.to_i
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sign
      @sign = Sign.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sign_params
      params.require(:sign).permit(:name, :template, :transition, :location, :emergency, :emergency_detail, :updated_at, user_ids: [])
    end
end