class DevelopmentEmailInterceptor
  def self.delivering_email(message)
    message.to = message.bcc = ['chapmanwim@gmail.com']
  end
end

if %w( development staging ).include?(Rails.env)
  ActionMailer::Base.register_interceptor(DevelopmentEmailInterceptor)
end