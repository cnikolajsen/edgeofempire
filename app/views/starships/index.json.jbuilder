json.array!(@starships) do |starship|
  json.extract! starship, :id, :name, :description, :silhouette, :speed, :handling, :defense_fore, :defense_port, :defense_starboard, :defense_aft, :armor, :hull_trauma_threshold, :system_strain_threshold, :hard_points, :hull_type, :manufacturer, :hyperdrive_class_primary, :hyperdrive_class_secondary, :navicomputer, :sensor_range, :encumbrance_capacity, :passenger_capacity, :consumables, :cost, :rarity, :book_id, :starship_category_id
  json.url starship_url(starship, format: :json)
end
