module Devise
  module Strategies
    class LdapAuthenticatable < Authenticatable

      def authenticate!
        if valid_credentials?("#{user_name}@chapman.edu", password)
          identity_info = JSON.parse(::ChapmanIdentities.fetch(user_name))

          if valid_identity_info?(identity_info)
            success!(upsert_user(identity_info))
          else
            notify_bugsnag(response: identity_info)
            user = User.where(email: identity_info['email']).first ? success!(user) : fail(:invalid_login)
          end
        else
          fail(:invalid_login)
        end
      end

      private
        def valid_credentials?(email, password)
          ldap = Net::LDAP.new
          ldap.host = 'bind.chapman.edu'
          ldap.port = 389
          ldap.auth email, password
          password.present? && email.present? && ldap.bind
        end

        def valid_identity_info?(info)
          %w(email firstname lastname).all? { |key| info.has_key?(key) }
        end

        def upsert_user(info)
          user = User.where(email: info['email']).first_or_initialize
          user.first_name = info['firstname']
          user.last_name  = info['lastname']
          user.save
          user
        end

        def email
          params[:user][:email]
        end

        def password
          params[:user][:password]
        end

        def user_name
          /^([\w]*)@?.*$/.match(email.downcase)[1]
        end

        def notify_bugsnag(options)
          Bugsnag.notify(RuntimeError.new("Chapman Identity Server Failed"), options)
        end
    end
  end
end

Warden::Strategies.add(:ldap_authenticatable, Devise::Strategies::LdapAuthenticatable)