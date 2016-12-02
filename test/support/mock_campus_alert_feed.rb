module MockCampusAlertFeed
  XML_TEMPLATE = <<-xml
<?xml version="1.0" encoding="UTF-8"?>
<rss xmlns:dc="http://purl.org/dc/elements/1.1/" version="2.0">
  <channel>
    <title>Mock Chapman Panther Alerts</title>
    <link>http://www.getrave.com/rss/chapman/channel1</link>
    <description>Welcome to Panther-Alert, Chapman University’s Emergency Notification system.  Panther-Alert sends emergency messages to your mobile or fixed device of choice so you get emergency messages quickly wherever you are.</description>
    <category>Panther Alerts</category>
    <dc:subject>Panther Alerts</dc:subject>
    <image>
      <title>Mock Chapman Panther Alerts</title>
      <url>http://www.chapman.edu/campus-services/public-safety/_files/Panther-Alert-Logo-Web.jpg</url>
      <link>http://www.getrave.com/rss/chapman/channel1</link>
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

  def mock_campus_alert_feed_with_no_alerts
    stubbed_xml = format(XML_TEMPLATE, DEFAULT_ITEMS_BLOCK)
    stub_campus_alert_feed(body: stubbed_xml)
  end

  def mock_campus_alert_feed_with_alert
    items_xml = <<-xml
    <item>
      <title>It's the end of the world as we know it.</title>
      <link />
      <description>I feel fine.</description>
      <enclosure url="http://www.chapman.edu/campus-services/public-safety/_files/Panther-Alert-Logo-Web.jpg" />
      <category>EMERGENCY</category>
      <pubDate>Tue, 22 Nov 2016 18:04:17 GMT</pubDate>
      <guid />
      <dc:date>2016-11-22T18:04:17Z</dc:date>
    </item>
    xml

    stubbed_xml = format(XML_TEMPLATE, items_xml)
    stub_campus_alert_feed(body: stubbed_xml)
  end

  def mock_campus_alert_feed_unavailable
    stub_campus_alert_feed(status: 404)
  end

  def stub_campus_alert_feed(options = {})
    body = options.fetch(:body, '')
    status = options.fetch(:status, 200)
    alert_feed_host = Rails.configuration.x.campus_alert.feed

    stub_request(:get, alert_feed_host).to_return(body: body, status: status)
  end

  def turn_vcr_off
    # VCR does not play nice with Webmock stubs: https://github.com/vcr/vcr/issues/146
    VCR.turn_off!
    WebMock.enable!
    Rails.cache.clear
  end

  def turn_vcr_on
    VCR.turn_on!
  end
end
