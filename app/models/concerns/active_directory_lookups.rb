module ActiveDirectoryLookups
  extend ActiveSupport::Concern

  class_methods do

    def create_or_update_from_active_directory(username)
      data = lookup_in_active_directory(username)
      user = User.where(email: data['email']).first_or_initialize
      user.first_name = data['firstname']
      user.last_name  = data['lastname']
      user.save
      user
    end

    def lookup_in_active_directory(username)
      data = JSON.parse(request(username))
      raise UnexpectedActiveDirectoryFormat unless valid_identity_info?(data)
      data
    end

    private

      def valid_identity_info?(info)
        %w(email firstname lastname).all? { |key| info.has_key?(key) }
      end

      def request(username)
        username     = URI::escape(username.gsub(/@chapman\.edu|@mail\.chapman\.edu/, '')) # Get rid of the @chapman part of the email if they have it
        uri          = URI.parse(Rails.application.secrets.chapman_identities_base_url + username)
        http         = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        request      = Net::HTTP::Get.new(uri.request_uri)
        request.basic_auth(Rails.application.secrets.chapman_identities_username, Rails.application.secrets.chapman_identities_password)
        response     = http.request(request)
        raise ChapmanIdentityNotFound if response.code != "200"
        response.body
      end
  end
end

# Errors Classes
class UnexpectedActiveDirectoryFormat < StandardError; end
class ChapmanIdentityNotFound < StandardError; end