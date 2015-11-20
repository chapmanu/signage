class NotificationsController < ApplicationController
  layout 'admin'
  def index
    @activites = PublicActivity::Activity.order(created_at: :desc)
  end
end
