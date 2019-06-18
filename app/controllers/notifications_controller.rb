class NotificationsController < ApplicationController
  layout 'admin'

  def index
    @unapproved_sign_slides = SignSlide.joins(sign: :sign_users).eager_load(:sign, :slide).where('sign_users.user_id' => current_user.id).where(approved: false)
    @user_slides_collection = current_user.sign_slides_awaiting_approval.paginate(page: params[:page], per_page: 10)
  end
end