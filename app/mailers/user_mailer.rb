class UserMailer < ApplicationMailer

  def sign_slide_request(args)
    @requestor = args[:requestor]
    @sign      = args[:sign_slide].sign
    @slide     = args[:sign_slide].slide
    @owners    = @sign.owners
    mail to: @owners.map(&:email), subject: "Play Slide Request: #{@slide.menu_name}"
  end

  def sign_slide_approved(args)
    @greeting = "Hi"

    mail to: "to@example.org"
  end

  def sign_slide_rejected(args)
    @greeting = "Hi"

    mail to: "to@example.org"
  end

  def sign_remove_owner(args)
    @user = args[:user]
    @sign = args[:item]
    mail(to: @user.email, subject: "You have been removed as an owner of the sign '#{@sign.name}'")
  end

  def sign_add_owner(args)
    @user = args[:user]
    @sign = args[:item]
    mail(to: @user.email, subject: "You have been added as an owner of the sign '#{@sign.name}'")
  end

  def slide_remove_owner(args)
    @user = args[:user]
    @slide = args[:item]
    mail(to: @user.email, subject: "You have been removed as an owner of the slide '#{@slide.name}'")
  end

  def slide_add_owner(args)
    @user = args[:user]
    @slide = args[:item]
    mail(to: @user.email, subject: "You have been added as an owner of the slide '#{@slide.name}'")
  end
end
