class DevicesController < ApplicationController
  before_action :set_device, only: [:poll, :show, :edit, :update, :destroy]
  layout 'admin', except: [:show]

  def order
    params[:device_slide_ids].each_with_index do |id, index|
      DeviceSlide.find(id).update(order: index)
    end
    render nothing: true
  end

  def poll
    @device.touch_last_ping
    last_updated = Time.zone.parse(device_params[:updated_at])
    @refresh = @device.updated_at.to_i > last_updated.to_i
  end

  # GET /devices
  # GET /devices.json
  def index
    @devices = Device.includes(:slides).search(params[:search]).order(:name)
  end

  # GET /devices/1
  # GET /devices/1.json
  def show
  end

  # GET /devices/new
  def new
    @device = Device.new
  end

  # GET /devices/1/edit
  def edit
  end

  # POST /devices
  # POST /devices.json
  def create
    @device = Device.new(device_params)

    respond_to do |format|
      if @device.save
        format.html { redirect_to edit_device_path @device; flash[:notice] = 'Device was successfully created.' }
        format.json { render :show, status: :created, location: @device }
      else
        format.html { render :new }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /devices/1
  # PATCH/PUT /devices/1.json
  def update
    respond_to do |format|
      if @device.update(device_params)
        format.html { redirect_to edit_device_path @device; flash[:notice] = 'Device was successfully updated.' }
        format.json { render :show, status: :ok, location: @device }
      else
        format.html { render :edit }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /devices/1
  # DELETE /devices/1.json
  def destroy
    @device.destroy
    respond_to do |format|
      format.html { redirect_to devices_url, notice: 'Device was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_device
      @device = Device.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def device_params
      params.require(:device).permit(:name, :template, :location, :emergency, :emergency_detail, :updated_at)
    end
end
