class HomeController < ApplicationController
	layout 'admin'

	def index
		@unapproved_sign_slides = SignSlide.joins(sign: :sign_users).eager_load(:sign, :slide).where('sign_users.user_id' => current_user.id).where(approved: false)
		query = PublicActivity::Activity.order(created_at: :desc)
    query = visible_activities(query) unless current_user.super_admin?
    @activities = query.take(20)
    render 'notifications/index'
	end

  private
    def visible_activities(query)
      query.select do |activity|
        if activity.trackable_type == 'Sign' && Sign.exists?(activity.trackable_id)
          sign = Sign.find(activity.trackable_id)
          sign.listed? || sign.users.include?(current_user) ? true : false
        else # trackable_type == 'Slide' || Sign has been deleted
            true
        end
      end
    end
    
end