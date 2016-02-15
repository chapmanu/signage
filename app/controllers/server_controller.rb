class ServerController < ApplicationController
  layout 'admin'

  def index
    @memory_stats = `df -h`
  end
end
