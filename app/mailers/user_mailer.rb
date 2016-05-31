class UserMailer < ApplicationMailer

  def sign_slide_request(args)
    @requestor = args[:requestor]
    @sign      = args[:sign_slide].sign
    @slide     = args[:sign_slide].slide
    @owners    = @sign.owners
    attachments.inline['screenshot.png'] = File.read(@slide.screenshot.path) if @slide.screenshot.path
    mail to: @owners.map(&:email), subject: "Play Slide Request: #{@slide.menu_name}"
  end

  def sign_slide_approved(args)
    @approver     = args[:approver]
    @sign         = args[:sign_slide].sign
    @slide        = args[:sign_slide].slide
    @message      = args[:message]
    @slide_owners = @slide.owners
    mail to: @slide_owners.map(&:email), subject: "Slide Approved to Play on #{@sign.name}"
  end

  def sign_slide_rejected(args)
    @rejector     = args[:rejector]
    @sign         = args[:sign_slide].sign
    @slide        = args[:sign_slide].slide
    @message      = args[:message]
    @slide_owners = @slide.owners
    mail to: @slide_owners.map(&:email), subject: "Slide Rejected to Play on #{@sign.name}"
  end

  def sign_remove_owner(args)
    @user = args[:user]
    @sign = args[:item]
    mail(to: @user.email, subject: "You've been removed as an owner of the #{@sign.name} sign")
  end

  def sign_add_owner(args)
    @user = args[:user]
    @sign = args[:item]
    mail(to: @user.email, subject: "You've been added as an owner of the #{@sign.name} sign")
  end

  def slide_remove_owner(args)
    @user = args[:user]
    @slide = args[:item]
    mail(to: @user.email, subject: "You've been removed as an owner of the #{@slide.menu_name} slide")
  end

  def slide_add_owner(args)
    @user = args[:user]
    @slide = args[:item]
    mail(to: @user.email, subject: "You've been added as an owner of the #{@slide.menu_name} slide")
  end
end
