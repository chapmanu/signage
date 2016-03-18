class AdminController < ApplicationController
  layout 'admin'
  skip_before_action :authenticate_user!, only: [:choose_sign]

  def index
  end

  def emergency
    @signs = Sign.all.order(:name)
  end

  def update_emergency
    Sign.where(id: params[:sign_ids]).update_all(emergency_params)
    redirect_to admin_emergency_path, alert: "Emergency message was successfully broadcasted"
  end

  def clear_single_emergency
    Sign.find(params[:id]).update(emergency_params)
    redirect_to admin_emergency_path, alert: "Emergency message successfully cleared"
  end

  def clear_all_emergencies
    Sign.all.update_all(emergency: nil, emergency_detail: nil)
    redirect_to admin_emergency_path, alert: "All emergency messages have been cleared"
  end

  def sessions
  end

  def choose_sign
    @signs = Sign.includes(:slides).order(:name)
  end

  private
    def emergency_params
      params.permit(:emergency, :emergency_detail)
    end
end
