class FetchDeviceDataJob < ActiveJob::Base
  queue_as :default

  def perform(_args)
    args     = HashWithIndifferentAccess.new(_args)
    response = RestClient.get args[:url]
    data     = JSON.parse(response.body)

    Device.transaction do
      device         = save_device(data)
      device.slides  = save_slides(data['collection'] || [])
      device.save!
    end
  end

  private
    def save_device(data)
      device = Device.where(name: data['id'].parameterize).first_or_initialize
      data.except(*excluded_keys).each do |key, value|
        device[key.underscore] = value
      end
      device.save!
      device
    end

    def save_slides(data)
      data.map do |item|
        slide = Slide.where(name: item['id']).first_or_initialize
        # The easy stuff where it maps directly
        item.except(*excluded_keys).each { |k, v| slide[k.underscore] = v }
        # The association stuff
        slide.people          = save_people(item['collection'] || [])          if slide.people_slide?
        slide.scheduled_items = save_scheduled_items(item['collection'] || []) if slide.schedule_slide?
        # The custom attribute processing
        slide_type_parts = slide.template.to_s[/(\w+)\.mustache$/, 1].underscore.split('_')
        slide.template   = slide_type_parts[0]
        slide.theme      = slide_type_parts[1]
        slide.layout     = slide_type_parts[2]
        slide.remote_background_url = 'http://www2.chapman.edu' + slide['background'] unless slide['background'].blank?
        slide.remote_foreground_url = 'http://www2.chapman.edu' + slide['foreground'] unless slide['foreground'].blank?
        begin
          slide.save!
        rescue => e
          puts "Failed to Save #{slide.inspect}"
        end
        slide
      end
    end

    def save_people(data)
      data.map do |item|
        person = Person.where(email: item['email']).first_or_initialize
        item.except(*excluded_keys).each { |k, v| person[k.underscore] = v }
        person.save!
        person
      end
    end

    def save_scheduled_items(data)
      data.map do |item|
        scheduled_item = ScheduledItem.new
        item.except(*excluded_keys).each { |k, v| scheduled_item[k.underscore] = v }
        # Custom Processing
        scheduled_item.remote_image_url = 'http://www2.chapman.edu' + scheduled_item['image'] unless scheduled_item['image'].blank?
        begin
          scheduled_item.save!
        rescue => e
          puts "Failed to Save #{scheduled_item.inspect}"
        end
        scheduled_item
      end
    end

    def excluded_keys
      %w(id collection)
    end
end
