json.array!(@adversaries) do |adversary|
  json.extract! adversary, :id, :name, :description, :brawn, :agility, :intellect, :cunning, :willpower, :presence, :soak, :defense_ranged, :defense_melee, :wounds, :strain, :race_id, :abilities, :slug
  json.url adversary_url(adversary, format: :json)
end
