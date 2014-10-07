json.array!(@duties) do |duty|
  json.extract! duty, :id, :name, :description, :career_id
  json.url duty_url(duty, format: :json)
end
