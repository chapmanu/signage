class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@mail.chapman.edu"
  layout 'mailer'
end
