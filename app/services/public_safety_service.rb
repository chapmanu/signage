#
# Service class pattern based on Engine Yard example:
# http://www.engineyard.com/blog/keeping-your-rails-controllers-dry-with-services
#
# TODO: This implementation is too tightly coupled with Chapman. Make it more
# flexible for other organizations using this project.
#
class PublicSafetyService
  # This is the title the Chapman alert feed is expected to have if there is no
  # emergency.
  # TODO: Check with Public Safety to see if this message if machine or user
  # generated. If user-generated, this is dangerous since it means user inputs
  # it once the emergency is complete and if they don't input it as expected,
  # signs would continue to display emergency alert.
  NO_EMERGENCY_TITLE = 'There is currently no emergency.'.freeze

  # Static/Class Methods
  class << self
    def all_clear?
      return true if emergency_feed.empty?
      latest_emergency_feed_message['title'] == NO_EMERGENCY_TITLE
    end

    def emergency_alert?
      ! all_clear?
    end

    def latest_emergency_feed_message
      emergency_feed.last
    end

    private

    def emergency_feed
      # This was set as a class constant FEED_URL originally. But it complicated testing.
      feed_url = Rails.configuration.x.public_safety.feed

      # Skip if Rails.configuration.x.public_safety is blank.
      return [] if feed_url.blank?

      # Check cache then campus alert feed.
      Rails.cache.fetch('public-safety-emergency-feed', expires_in: 60.seconds) do
        # Require SSL certificate verification only in production.
        verify_ssl = Rails.env.production?

        # verify_ssl is not accepted in RestCient.get per https://stackoverflow.com/a/38500706/6763239
        begin
          response = RestClient::Request.execute(url: feed_url,
                                                 method: :get,
                                                 verify_ssl: verify_ssl)
        rescue => e
          # If request fails, return empty array.
          return []
        end

        data = Hash.from_xml(response)
        items = data["rss"]["channel"]["item"]

        # If multiple items, then items is an array of hashes, else a single hash
        items.is_a?(Array) ? items : [items]
      end
    end
  end
  # End Static/Class Methods
end
