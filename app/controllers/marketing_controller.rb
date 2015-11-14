class MarketingController < ApplicationController
  skip_before_action :authenticate_user
  layout 'marketing'

  def home
  end
end
