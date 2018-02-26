module Devise
  module Strategies
    class LdapAuthenticatable < Authenticatable

      def authenticate!
        if valid_credentials?("#{username}@chapman.edu", password)          
          success! User.create_or_update_from_active_directory(username)
        else
          fail(:invalid_login)
        end
      rescue UnexpectedActiveDirectoryFormat
        fail(:invalid_login)
      #if identity issue occurs in create_or_update_from_active_directory method ChapmanandIdentityNotFound 
      #error is raised and with user information reported to bugsnag in rescue
      rescue ChapmanIdentityNotFound
        user = User.where(email: "#{username}@chapman.edu")
        identity_info = User.lookup_in_active_directory(username)

        notify_bugsnag(user: user, response: identity_info)
        fail(:invalid_identity_info)
      end


      private
        def valid_credentials?(email, password)
          ldap = Net::LDAP.new
          ldap.host = 'bind.chapman.edu'
          ldap.port = 389
          ldap.auth email, password
          password.present? && email.present? && ldap.bind
        end

        def email
          params[:user][:email]
        end

        def password
          params[:user][:password]
        end

        def username
          /^([\w]*)@?.*$/.match(email.downcase)[1]
        end

        def notify_bugsnag(options)
          Bugsnag.notify(RuntimeError.new("Chapman Identity Server Failed"), options)
        end
    end
  end
end

Warden::Strategies.add(:ldap_authenticatable, Devise::Strategies::LdapAuthenticatable)