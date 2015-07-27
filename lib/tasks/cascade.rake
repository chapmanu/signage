namespace :cascade do
  desc "Fetch data from Cascade"

  task sync: :environment do
    puts "Fetching data from cascade"
    cascade = Rails.application.config_for :cascade

    cascade['devices'].map do |device_name|
      url = cascade['endpoint'].gsub(':device', device_name)
      FetchDeviceDataJob.perform_now(url: url)
    end
  end

end
