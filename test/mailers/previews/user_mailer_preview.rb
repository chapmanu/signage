# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/sign_slide_request
  def sign_slide_request
    UserMailer.sign_slide_request(sign_slide: SignSlide.take, requestor: User.take)
  end

  def sign_slide_approved
    UserMailer.sign_slide_approved(approver: User.take, sign_slide: SignSlide.take)
  end

  def sign_slide_rejected
    UserMailer.sign_slide_rejected(rejector: User.take, sign_slide: SignSlide.take)
  end
end
