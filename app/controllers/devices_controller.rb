class DevicesController < ApplicationController
  before_action :set_device, only: [:show, :poll]
  layout 'admin'

  # GET /devices
  # GET /devices.json
  def index
    @devices = Device.includes(:slides).all
  end

  # GET /devices/1
  # GET /devices/1.json
  def show
    render layout: 'application'
  end

  def poll
    last_updated = Time.zone.parse(device_params[:updated_at])
    @refresh = @device.updated_at.to_i > last_updated.to_i
  end

  private
    def set_device
      @device = Device.find_by_name(params[:id])
    end

    def device_params
      params[:device].permit(:updated_at);
    end
end