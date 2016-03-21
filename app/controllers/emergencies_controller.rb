class EmergenciesController < ApplicationController
  
  before_action :authorize_as_super_admin!

  layout 'admin'

  def index
    @signs = Sign.all.order(:name)
  end

  def create
    Sign.where(id: params[:sign_ids]).update_all(emergency_params)
    redirect_to emergencies_path, alert: "Emergency message was successfully broadcasted"
  end

  def destroy
    if params[:id] == 'all'
      Sign.all.update_all(emergency: nil, emergency_detail: nil)
      redirect_to emergencies_path, alert: "Emergency message successfully cleared"
    else
      Sign.find(params[:id]).update(emergency_params)
      redirect_to emergencies_path, alert: "All emergency messages have been cleared"
    end
  end

  private
    def emergency_params
      params.permit(:emergency, :emergency_detail)
    end
end
