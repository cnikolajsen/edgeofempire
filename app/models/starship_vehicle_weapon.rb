class StarshipVehicleWeapon < ActiveRecord::Base
  belongs_to :starship
  belongs_to :vehicle_weapon
end
