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

    def emergency_alert?
      latest_emergency_feed_message.title != NO_EMERGENCY_TITLE
    end

    def latest_emergency_feed_message
    end

    private

    def emergency_feed
    end
  end
  # End Static/Class Methods
end
