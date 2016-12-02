class MockController < ApplicationController
  skip_before_action :authenticate_user!
  layout nil

  # GET /mock/campus_alerts_feed/
  # GET /mock/campus_alerts_feed/emergency
  def campus_alerts_feed
    # By adding an alerts-feed to the signs/play url, user can specify this as a mock feed.
    # For example:
    # /signs/test-sign/play?alerts-feed=http://localhost:3000/mock/campus_alerts_feed/emergency
    # This only works in non-production environments.
    if params['status'] == 'emergency'
      file_name = 'campus_feed_emergency.xml'
    else
      file_name = 'campus_feed_no_emergency.xml'
    end

    xml_path = Rails.root.join('test', 'fixtures', 'files', file_name)
    render text: File.read(xml_path).html_safe, content_type: 'application/xml'
  end

  # GET /mock/test
  def test
    render text: 'ok'
  end
end