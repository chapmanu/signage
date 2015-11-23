class UserMailer < ApplicationMailer

  def sign_slide_request(args)
    @greeting = "Hi"

    mail to: "to@example.org"
  end

  def sign_slide_approved(args)
    @greeting = "Hi"

    mail to: "to@example.org"
  end

  def sign_slide_rejected(args)
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
