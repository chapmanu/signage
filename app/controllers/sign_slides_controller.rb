class SignSlidesController < ApplicationController
  before_action :set_sign_slide

  def approve
    @sign_slide.update(approved: true)
    @sign_slide.sign.touch
  end

  def reject
    @sign_slide.destroy
    @sign_slide.sign.touch
  end

  private

    def set_sign_slide
      @sign_slide = SignSlide.find(params[:id])
    end
end
