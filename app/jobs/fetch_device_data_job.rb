class FetchDeviceDataJob < ActiveJob::Base
  queue_as :default

  def perform(_args)
    args     = HashWithIndifferentAccess.new(_args)
    response = RestClient.get args[:url]
    data     = JSON.parse(response.body)

    Device.transaction do
      device = save_device(data)
      save_slides(device, data['collection'] || [])
    end
  end

  private
    def save_device(data)
      device = Device.where(name: data['id'].parameterize).first_or_initialize
      device.template = data['template']
      device.location = data['location']
      device.save!
      device
    end

    def save_slides(device, data)
      data.map do |item|
        slide = Slide.where(name: item['id']).first_or_initialize
        slide.devices << device unless slide.devices.include?(device)

        slide_type_parts            = item['template'].to_s[/(\w+)\.mustache$/, 1].underscore.split('_')
        slide.template              = slide_type_parts[0]
        slide.theme                 = slide_type_parts[1]
        slide.layout                = slide_type_parts[2]
        slide.remote_background_url = 'http://www2.chapman.edu' + item['background'] unless item['background'].blank?
        slide.remote_foreground_url = 'http://www2.chapman.edu' + item['foreground'] unless item['foreground'].blank?
        slide.menu_name             = item['menuName']
        slide.organizer             = item['organizer']
        slide.organizer_id          = item['organizerId']
        slide.duration              = item['duration']
        slide.heading               = item['heading']
        slide.subheading            = item['subheading']
        slide.location              = item['location']
        slide.content               = item['content']
        slide.background_type       = item['backgroundType']
        slide.background_sizing     = item['backgroundSizing']
        slide.foreground_type       = item['foregroundType']
        slide.foreground_sizing     = item['foregroundSizing']
        slide.directory_feed        = nil # To be determined
        slide.play_on               = item['start_slide_on'].blank?  ? nil : parse_date(item['start_slide_on'])
        slide.stop_on               = item['end_slide_after'].blank? ? nil : parse_datetime(item['end_slide_after'])
        slide.show                  = item['show_slide'] == 'Yes'
        slide.datetime              = item['datetime']

        # The associations
        slide.scheduled_items = save_scheduled_items(item['collection'] || []) if slide.schedule_slide?
        begin
          slide.save!
        rescue => e
          puts "#{e.inspect}"
        end
        slide
      end
    end

    def save_scheduled_items(data)
      data.map do |item|
        scheduled_item                  = ScheduledItem.new
        scheduled_item.date             = item['date']
        scheduled_item.time             = item['time']
        scheduled_item.name             = item['name']
        scheduled_item.content          = item['content']
        scheduled_item.admission        = item['admission']
        scheduled_item.audience         = item['audience']
        scheduled_item.location         = item['location']
        scheduled_item.play_on          = item['start_displaying_event_on'].blank?   ? nil : parse_date(item['start_displaying_event_on'])
        scheduled_item.stop_on          = item['stop_displaying_event_after'].blank? ? nil : parse_date(item['stop_displaying_event_after']).end_of_day
        scheduled_item.remote_image_url = 'http://www2.chapman.edu' + item['image'] unless item['image'].blank?
        begin
          scheduled_item.save!
        rescue => e
          puts "Failed to Save #{scheduled_item.inspect} #{e.inspect}"
        end
        scheduled_item
      end
    end

    def excluded_keys
      %w(id collection)
    end

    def parse_date(string)
      DateTime.strptime(string, '%m-%d-%Y')
    end

    def parse_datetime(string)
      DateTime.strptime(string, '%m-%d-%Y %H:%M')
    end
end
