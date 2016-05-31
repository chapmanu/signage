# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/sign_slide_request
  def sign_slide_request
    UserMailer.sign_slide_request(sign_slide: SignSlide.take, requestor: User.take)
  end

  def sign_slide_sans_message_approved
    UserMailer.sign_slide_approved(approver: User.take, sign_slide: SignSlide.take)
  end

  def sign_slide_sans_message_rejected
    UserMailer.sign_slide_rejected(rejector: User.take, sign_slide: SignSlide.take)
  end

  def sign_slide_with_message_approved
    UserMailer.sign_slide_approved(approver: User.take, sign_slide: SignSlide.take, message: "Arbitrary approval message")
  end

  def sign_slide_with_message_rejected
    UserMailer.sign_slide_rejected(rejector: User.take, sign_slide: SignSlide.take, message: "Arbitrary rejection message")
  end

  def sign_remove_owner
    UserMailer.sign_remove_owner(item: Sign.take, user: User.take)
  end

  def sign_add_owner
    UserMailer.sign_add_owner(item: Sign.take, user: User.take)
  end

  def slide_remove_owner
    UserMailer.slide_remove_owner(item: Slide.take, user: User.take)
  end

  def slide_add_owner
    UserMailer.slide_add_owner(item: Slide.take, user: User.take)
  end

  # def slide_remove_owner(args)
  #   @user = args[:user]
  #   @slide = args[:item]
  #   mail(to: @user.email, subject: "You have been removed as an owner of the slide '#{@slide.name}'")
  # end

  # def slide_add_owner(args)
  #   @user = args[:user]
  #   @slide = args[:item]
  #   mail(to: @user.email, subject: "You have been added as an owner of the slide '#{@slide.name}'")
  # end
end
