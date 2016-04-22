class NotificationsController < ApplicationController

  layout 'admin'

  def index
    @unapproved_sign_slides = SignSlide.joins(sign: :sign_users).eager_load(:sign, :slide).where('sign_users.user_id' => current_user.id).where(approved: false)
    @activites = PublicActivity::Activity.order(created_at: :desc).limit(20)
  end

  def notifications
    @unapproved_sign_slides = SignSlide.joins(sign: :sign_users).eager_load(:sign, :slide).where('sign_users.user_id' => current_user.id).where(approved: false)
    render :index
  end
end