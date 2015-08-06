json.array!(@slides) do |slide|
  json.extract! slide, :id, :name, :template, :menu_name, :organizer, :organizer_id, :duration, :heading, :subheading, :datetime, :location, :content, :background, :background_type, :background_sizing, :foreground, :foreground_type, :foreground_sizing
  json.url slide_url(slide, format: :json)
end
