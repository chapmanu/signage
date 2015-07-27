class DevicesController < ApplicationController
  before_action :set_device, only: [:show, :edit, :update, :destroy]

  # GET /devices
  # GET /devices.json
  def index
    @devices = Device.includes(:slides).all
  end

  # GET /devices/1
  # GET /devices/1.json
  def show
  end

  private
    def set_device
      @device = Device.find_by_name(params[:id])
    end
end