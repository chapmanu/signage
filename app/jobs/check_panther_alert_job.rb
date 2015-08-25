class CheckPantherAlertJob < ActiveJob::Base
  queue_as :default

  URL = 'https://rss.blackboardconnect.com/138874/digital-signage/feed.xml'

  def perform
    response = RestClient.get CheckPantherAlertJob::URL
    data     = Hash.from_xml(response)
    messages = data["rss"]["channel"]["item"]
    updates  = { panther_alert: nil, panther_alert_detail: nil }

    if messages && messages.is_a?(Array) && !messages.empty?
      updates[:panther_alert]        = messages[0]["title"]
      updates[:panther_alert_detail] = messages[0]["description"]
    end

    Device.update_all(updates)
    updates
  end
end
