json.array!(@obligations) do |obligation|
  json.extract! obligation, :id, :name, :description, :career_id
  json.url obligation_url(obligation, format: :json)
end
