class ChapmanIdentities
  class << self
    def fetch(user_name)
      api_base_url = Rails.application.secrets.chapman_identities_base_url
      api_user     = Rails.application.secrets.chapman_identities_username
      api_password = Rails.application.secrets.chapman_identities_password

      user_name = URI::escape(user_name.gsub(/@chapman\.edu|@mail\.chapman\.edu/, '')) # Get rid of the @chapman part of the email if they have it
      uri  = URI.parse(api_base_url + user_name)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(uri.request_uri)
      request.basic_auth(api_user, api_password)
      response = http.request(request)

      raise ChapmanIdentityNotFound if response.code != "200"
      response.body
    end
  end
end
class ChapmanIdentityNotFound < StandardError; end
