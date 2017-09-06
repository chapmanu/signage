#
# Service class pattern based on Engine Yard example:
# http://www.engineyard.com/blog/keeping-your-rails-controllers-dry-with-services
#
class PublicSafetyService
  # Static/Class Methods
  class << self
    # This is the title the Chapman alert feed is expected to have if there is no
    # emergency.
    # TODO: Check with Public Safety to see if this message if machine or user
    # generated. If user-generated, this is dangerous since it means user inputs
    # it once the emergency is complete and if they don't input it as expected,
    # signs would continue to display emergency alert.
    NO_EMERGENCY_TITLE = 'There is currently no emergency.'.freeze
    FEED_URL = Rails.configuration.x.public_safety.feed.freeze

    def all_clear?
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
      # Check cache then campus alert feed.
      Rails.cache.fetch('public-safety-emergency-feed', expires_in: 60.seconds) do
        # Require SSL certificate verification only in production.
        verify_ssl = Rails.env.production?

        # verify_ssl is not accepted in RestCient.get per https://stackoverflow.com/a/38500706/6763239
        response = RestClient::Request.execute(url: FEED_URL,
                                               method: :get,
                                               verify_ssl: verify_ssl)
        data = Hash.from_xml(response)
        items = data["rss"]["channel"]["item"]

        # If multiple items, then items is an array of hashes, else a single hash
        items.is_a?(Array) ? items : [items]
      end
    end
  end
  # End Static/Class Methods
end
