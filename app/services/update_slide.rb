class UpdateSlide
  class << self

    def execute(slide, params, current_user)
      sign_slide_ids_was = slide.sign_slide_ids

      if slide.update(params)
        new_sign_slide_ids = (slide.sign_slide_ids - sign_slide_ids_was)
        set_sign_slide_approvals(new_sign_slide_ids, current_user)
        true
      else
        false
      end
    end

    private

      def set_sign_slide_approvals(new_sign_slide_ids, current_user)
        new_sign_slide_ids.each do |id|
          ss = SignSlide.find(id)
          if ss.sign.owned_by?(current_user)
            ss.update(approved: true)
          else
            UserMailer.sign_slide_request(sign_slide: ss, requestor: current_user).deliver_now
          end
        end
        true
      end

  end
end