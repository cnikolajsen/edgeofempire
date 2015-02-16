json.array!(@vehicle_weapons) do |vehicle_weapon|
  json.extract! vehicle_weapon, :id, :name, :range, :damage, :critical, :price, :rarity, :size_low, :size_high, :slug
  json.url vehicle_weapon_url(vehicle_weapon, format: :json)
end
