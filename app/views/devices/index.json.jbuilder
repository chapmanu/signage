json.array!(@devices) do |device|
  json.extract! device, :id, :name, :template, :location, :emergency, :emergency_detail, :updated_at
  json.url device_url(device, format: :json)
end
