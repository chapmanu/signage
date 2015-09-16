module Devise
  module Strategies
    class LdapAuthenticatable < Authenticatable

      def authenticate!
        if valid_credentials?("#{username}@chapman.edu", password)
          success! User.create_or_update_from_active_directory(username)
        else
          fail(:invalid_login)
        end

      rescue UnexpectedActiveDirectoryFormat, ChapmanIdentityNotFound
        fail(:invalid_login)
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