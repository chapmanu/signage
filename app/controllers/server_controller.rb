class ServerController < ApplicationController
  before_action :authorize_as_super_admin!

  layout 'admin'

  def index
    @memory_stats = `df -h`
  end
end
