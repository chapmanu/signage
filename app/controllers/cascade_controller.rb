class CascadeController < ApplicationController
  layout 'admin'

  def form
  end

  def import
    if valid_cascade_url?
      @sign = FetchDeviceDataJob.perform_now(url: "#{params[:cascade_url]}/slideshow.json")
      @sign.users << current_user
      @sign.slides.each(&:take_screenshot)
      redirect_to @sign, notice: "Successfully imported #{@sign.name}"
    else
      @error = "The provided url is invalid."
      render :form
    end
  rescue RestClient::ResourceNotFound
    @error = "Could not find a device from cascade at the provided url."
    render :form
  end

  private

    def valid_cascade_url?
      params[:cascade_url] =~ /^http:\/\/www2.chapman.edu\/digital-signage\/devices\/.+/
    end
end
