class VehicleWeaponQualityRank < ActiveRecord::Base
  belongs_to :vehicle_weapon
  belongs_to :weapon_quality
end
