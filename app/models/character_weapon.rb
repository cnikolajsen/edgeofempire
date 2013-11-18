class CharacterWeapon < ActiveRecord::Base
  #attr_accessible :character_id, :weapon_id
  
  belongs_to :character
  belongs_to :weapon
  
end
