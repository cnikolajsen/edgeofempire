class CharacterForcePowerUpgrade < ActiveRecord::Base
  belongs_to :character_force_power
  belongs_to :character
  belongs_to :force_power_upgrade
end
