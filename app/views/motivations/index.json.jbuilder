json.array!(@motivations) do |motivation|
  json.extract! motivation, :id, :name, :description, :career_id
  json.url motivation_url(motivation, format: :json)
end
