class CharacterForcePowerUpgrade < ActiveRecord::Base
  belongs_to :character_force_power
  belongs_to :character
end
