class ProductionEmailInterceptor
  def self.delivering_email(message)
    message.bcc ||= []
    message.bcc << 'chapmanwim@gmail.com'
  end
end

if Rails.env.production?
  ActionMailer::Base.register_interceptor(ProductionEmailInterceptor)
end