class CharacterArmor < ActiveRecord::Base
  attr_accessible :armor_id, :character_id

  belongs_to :character
  belongs_to :weapon
end
