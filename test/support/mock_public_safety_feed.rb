module MockPublicSafetyFeed
  # Based on https://content.getrave.com/rss/chapman/channel1
  XML_TEMPLATE = <<-xml
<?xml version="1.0" encoding="UTF-8"?>
<rss xmlns:dc="http://purl.org/dc/elements/1.1/" version="2.0">
  <channel>
    <title>Mock Chapman Panther Alerts</title>
    <link>https://content.getrave.com/rss/chapman/channel1</link>
    <description>Welcome to Panther-Alert, Chapman University’s Emergency Notification system.  Panther-Alert sends emergency messages to your mobile or fixed device of choice so you get emergency messages quickly wherever you are.</description>
    <category>Panther Alerts</category>
    <dc:subject>Panther Alerts</dc:subject>
    <image>
      <title>Mock Chapman Panther Alerts</title>
      <url>http://www.chapman.edu/campus-services/public-safety/_files/Panther-Alert-Logo-Web.jpg</url>
      <link>https://content.getrave.com/rss/chapman/channel1</link>
    </image>
    %s
  </channel>
</rss>
  xml

  DEFAULT_ITEMS_BLOCK = <<-xml
    <item>
      <title>There is currently no emergency.</title>
      <link />
      <description>There is currently no emergency at Chapman University.</description>
      <enclosure url="http://www.chapman.edu/campus-services/public-safety/_files/Panther-Alert-Logo-Web.jpg" />
      <category>Panther Alerts</category>
      <pubDate>Tue, 1 Dec 2016 12:00:00 GMT</pubDate>
      <guid />
      <dc:date>2016-12-01T12:00:00Z</dc:date>
    </item>
  xml

  def mock_no_public_safety_emergency_alert
    stubbed_xml = format(XML_TEMPLATE, DEFAULT_ITEMS_BLOCK)
    stub_public_safety_feed(body: stubbed_xml)
  end

  def mock_public_safety_emergency_alert
    items_xml = <<-xml
    <item>
      <title>It's the end of the world as we know it.</title>
      <link />
      <description>I feel fine.</description>
      <enclosure url="http://www.chapman.edu/campus-services/public-safety/_files/Panther-Alert-Logo-Web.jpg" />
      <category>Panther Alerts</category>
      <pubDate>Tue, 1 Dec 2016 12:00:00 GMT</pubDate>
      <guid />
      <dc:date>2016-12-01T12:00:00Z</dc:date>
    </item>
    xml

    stubbed_xml = format(XML_TEMPLATE, items_xml)
    stub_public_safety_feed(body: stubbed_xml)
  end

  def mock_public_safety_feed_unavailable
    stub_public_safety_feed(status: 404)
  end

  def stub_public_safety_feed(options = {})
    # Default options
    body = options.fetch(:body, '')
    status = options.fetch(:status, 200)

    alert_feed_host = Rails.configuration.x.public_safety.feed
    stub_request(:get, alert_feed_host).to_return(body: body, status: status)
  end
end
